require 'services/tmdb_api_service'

class MediaController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if params[:nb].blank?
      @nb = 0
      search_media
    else
      @nb = params['nb'].to_i
    end
    @medium = Medium.find(session[:media][@nb])
  end

  private

  def search_media
    session.delete(:media)
    if !params[:q].blank? && !advanced_search?
      session[:media] = Medium.search_in_all(params[:q]).map { |m| m.id }
    elsif advanced_search?
      session[:media] = call_api.map { |m| m.id }
    else
      session[:media] = Medium.all.first(500).map { |m| m.id }
    end
  end

  def call_api
    base_poster_url = 'http://image.tmdb.org/t/p/w500/'

    category_sort = TmdbApiService.new(params[:adv]).sort_by_genre unless params[:adv][:c].blank?
    actor_sort = TmdbApiService.new(params[:adv]).sort_by_actor unless params[:adv][:a].blank?
    director_sort = TmdbApiService.new(params[:adv]).sort_by_director unless params[:adv][:d].blank?

    result = (category_sort || [] + actor_sort || [] + director_sort || []).uniq
    media = []
    result.each do |movie|
      medium_found = Medium.find_by(title: movie['title'])
      detail_movie = TmdbApiService.call_movie(movie['id'])
      if medium_found
        medium = update_database(medium_found, detail_movie)
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
      poster: 'http://image.tmdb.org/t/p/w500/' << (movie['poster_path'].blank? ? '' : movie['poster_path']),
      country: (movie['production_countries'].blank? ? nil : movie['production_countries'][0]['name']),
      language: movie['orginal_language'],
      studio: studio
      )

    return medium
  end

  def store_in_database(movie)
    movie_credits = TmdbApiService.call_movie_credits(movie['id'])

    studio = find_studio(movie)
    categories = find_categories(movie)
    actors = find_actors(movie_credits['cast'])
    directors = find_directors(movie_credits['crew'])

    medium = Medium.create(
      poster: 'http://image.tmdb.org/t/p/w500/' << (movie['poster_path'].blank? ? '' : movie['poster_path']),
      title: movie['title'],
      synopsys: movie['overview'],
      duration: movie['runtime'],
      year: movie['release_date'].match(/\d{4}/)[0],
      country: (movie['production_countries'].blank? ? nil : movie['production_countries'][0]['name']),
      press_rating: movie['vote_average'], # TODO: use IMDB for rating
      audience_rating: movie['vote_average'],
      language: movie['orginal_language'],
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
          actor.update(photo: 'http://image.tmdb.org/t/p/w500/' << (person[:photo].blank? ? '' : person[:photo]))
        end
      end

      if actor.nil?
        actor = Actor.create(
          first_name: first_name,
          last_name: last_name,
          photo: 'http://image.tmdb.org/t/p/w500/' << (person[:photo].blank? ? '' : person[:photo])
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
          director.update(photo: 'http://image.tmdb.org/t/p/w500/' << (person[:photo].blank? ? '' : person[:photo]))
        end
      end

      if director.nil?
        director = Director.create(
          first_name: first_name,
          last_name: last_name,
          photo: 'http://image.tmdb.org/t/p/w500/' + (person[:photo].blank? ? '' : person[:photo])
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
