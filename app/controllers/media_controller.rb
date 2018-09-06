require 'services/tmdb_api_service'
require 'pp'

class MediaController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:chatbot]

  def index
    if params[:nb].blank?
      @nb = 0
      # search_media
    else
      @nb = params['nb'].to_i
    end
    @medium = Medium.find(session[:media][@nb])
  end

  def chatbot
    session.delete(:media)
    data = JSON.parse(request.body.read)['conversation']['memory']

    if data.has_key? 'movie'
      title_search = TmdbApiService.new(data['movie']['raw']).search_movie
    end

    if data.has_key? 'genre'
      genre_search = TmdbApiService.new(data['genre']['raw']).sort_by_genre
    end

    if data.has_key? 'person'
      person_search = TmdbApiService.new(data['person']['raw']).search_person
    end

    movies = (title_search || [] + genre_search || [] + person_search || []).compact

    movies_count = movies.uniq.map do |movie|
      movies.count(movie)
    end

    movies_sorted = movies.group_by{|x| x}.sort_by{|k, v| -v.size}.map(&:first)

    session[:media] = fetch_to_database(movies_sorted).map { |m| m.id }.compact

    pp movies_sorted
    p movies_sorted.count
    pp data
    redirect_to discover_path
  end

  private

  # def json_request?
  #   p request.body
  #   p request.format.json?
  # end

  def search_media
    session.delete(:media)
    if !params[:q].blank? && !advanced_search?
      session[:media] = simple_search_api.map { |m| m.id }.compact
    elsif advanced_search?
      session[:media] = advanced_search_api.map { |m| m.id }.compact
    else
      session[:media] = Medium.all.first(500).map { |m| m.id }
    end
  end

  def simple_search_api
    results = TmdbApiService.search(params[:q])
    fetch_to_database(results[:movie].uniq)
  end

  def advanced_search_api
    base_poster_url = 'http://image.tmdb.org/t/p/w500/'

    query_sort = TmdbApiService.search(params[:q])[:movie] unless params[:q].blank?
    category_sort = TmdbApiService.new(params[:adv]).sort_by_genre unless params[:adv][:c].blank?
    actor_sort = TmdbApiService.new(params[:adv]).sort_by_actor unless params[:adv][:a].blank?
    director_sort = TmdbApiService.new(params[:adv]).sort_by_director unless params[:adv][:d].blank?

    result = ((query_sort || []) + (category_sort || []) + (actor_sort || []) + (director_sort || [])).uniq
    fetch_to_database(result)
  end

  def fetch_to_database(result)
    media = []
    result.each do |movie|
      medium_found = Medium.find_by(title: movie['title'])
      detail_movie = TmdbApiService.call_movie(movie['id'])
      if medium_found
        medium = medium_found
      else
        medium = store_in_database(detail_movie)
      end
      media << medium
    end
    return media
  end

  def update_database(medium, movie)
    studio = find_studio(movie)

    medium.update(
      poster: (movie['poster_path'].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' << movie['poster_path']),
      country: (movie['production_countries'].blank? ? nil : movie['production_countries'][0]['name']),
      language: movie['original_language'],
      studio: studio
      )

    return medium
  end

  def store_in_database(movie)
    movie_credits = TmdbApiService.call_movie_credits(movie['id'])
    p movie
    studio = find_studio(movie)
    categories = find_categories(movie)
    actors = find_actors(movie_credits['cast'])
    directors = find_directors(movie_credits['crew'])

    medium = Medium.create(
      poster: (movie['poster_path'].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' << movie['poster_path']),
      title: movie['title'],
      synopsys: movie['overview'],
      duration: movie['runtime'],
      year: (movie['release_date'].blank? ? '' : movie['release_date'].match(/\d{4}/)[0]),
      country: (movie['production_countries'].blank? ? nil : movie['production_countries'][0]['name']),
      press_rating: movie['vote_average'], # TODO: use IMDB for rating
      audience_rating: movie['vote_average'],
      language: movie['original_language'],
      studio: studio
      )
    medium.categories = categories
    medium.actors = actors
    medium.directors = directors
    return medium
  end

  def find_studio(movie)
    unless movie['production_companies'].blank?
      studio = Studio.find_by(name: movie['production_companies'][0]['name'])
      studio = Studio.create(name: movie['production_companies'][0]['name']) if studio.nil?
    end
    return studio
  end

  def find_categories(movie)
    categories = []
    names = movie['genres'].map { |c| c['name'] }
    names.each do |name|
      category = Category.find_by(name: name)
      category = Category.create(name: name) if category.nil?
      categories << category
    end
    return categories
  end

  def find_actors(cast)
    actors = []
    cast = cast.map { |c| {name: c['name'], photo: c['profile_path']} }
    cast.each do |person|
      p person
      names = person[:name].split(' ')
      if names.length == 1
        names = [names.first, names.first]
      else
        if names.length > 2
          names = [names[0..-2].join(' '), names.last]
        end
      end

      first_name = names[0]
      last_name = names[1]

      actor = nil
      Actor.where(last_name: last_name).each do |actor_family|
        if actor_family.first_name == first_name
          actor = actor_family
          actor.update(photo: (person[:photo].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' << person[:photo]))
        end
      end

      if actor.nil?
        actor = Actor.create(
          first_name: first_name,
          last_name: last_name,
          photo: (person[:photo].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' << person[:photo])
          )
      end
      actors << actor
    end
    return actors
  end

  def find_directors(crew)
    directors = []
    crew = crew.map { |c| {name: c['name'], photo: c['profile_path']} if c['job'] == 'Director' }
    crew.compact.each do |person|

      names = person[:name].split(' ')
      if names.length == 1
        names = [names.first, names.first]
      else
        if names.length > 2
          names = [names[0..-2].join(' '), names.last]
        end
      end

      first_name = names[0]
      last_name = names[1]

      director = nil
      Director.where(last_name: last_name).each do |director_family|
        if director_family.first_name == first_name
          director = director_family
          director.update(photo: (person[:photo].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' <<  person[:photo]))
        end
      end

      if director.nil?
        director = Director.create(
          first_name: first_name,
          last_name: last_name,
          photo: (person[:photo].blank? ? '' : 'http://image.tmdb.org/t/p/w500/' << person[:photo])
          )
      end
      directors << director
    end
    return directors
  end

  def advanced_search?
    unless params[:adv].nil?
      !(
        params[:adv][:c].blank? &&
        params[:adv][:mood].blank? &&
        params[:adv][:country].blank? &&
        params[:adv][:a].blank? &&
        params[:adv][:d].blank? &&
        params[:adv][:studio].blank? &&
        params[:adv][:seen].nil? &&
        params[:adv][:recent].nil? &&
        params[:adv][:netflix].nil? &&
        params[:adv][:amazon].nil?
      ) # TODO : add rule for year and duration
    end
  end
end
