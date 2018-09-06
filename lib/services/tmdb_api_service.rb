require "json"
require "rest-client"

class TmdbApiService
  def initialize(data)
    @data = data
    @key = ENV['TMDB_KEY']
    @base_url = 'https://api.themoviedb.org/3/'
  end

  # def call
  #   response = RestClient.get "#{@base_url}#{@key}&#{serialize(@data)}"
  #   data = JSON.parse(response.body)["Search"]
  #   data.each_with_object([]) do |r, a|
  #     a << JSON.parse((RestClient.get "#{@base_url}#{@key}&i=#{r['imdbID']}").body)
  #   end
  # end

  # def serialize(args)
  #   #here we put some symbol for answer from the form
  #   # :d for director, :a for actor, :c for category, y for release year, t for duration (in min)
  #   array = []
  #   args.each do |k, v|
  #     if k == :d
  #       array << "#{v.gsub(' ', '%20')}"
  #     elsif k == :a
  #       array << "#{v.gsub(' ', '%20')}"
  #     elsif k == :c
  #       array << "#{v.gsub(' ', ', ')}"
  #     elsif k == :tmin
  #       array << "with_runtime.gte=#{@data[:tmin]}"
  #     elsif k == :tmax
  #       array << "with_runtime.lte=#{@data[:tmax]}"
  #     elsif k == :ymin
  #       array << "primary_release_date.gte=#{@data[:ymin]}-01-01"
  #     elsif k == :ymax
  #       array << "primary_release_date.lte=#{@data[:ymax]}-12-31"
  #     else
  #       array << "#{k}=#{v}"
  #     end
  #   end
  #   array.join('&')
  # end

  def sort_by_director
    d = serialize(@data)
    response = RestClient.get "https://api.tmdb.org/3/search/person?api_key=#{@key}&query=#{d}"
    director_id = JSON.parse(response)["results"][0]["id"]
    director = RestClient.get "#{@base_url}person/#{director_id}/movie_credits?api_key=#{@key}"
    movies = JSON.parse(director)["cast"]
    movies.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def sort_by_actor
    a = serialize(@data)
    response = RestClient.get "https://api.tmdb.org/3/search/person?api_key=#{@key}&query=#{a}"
    actor_id = JSON.parse(response)["results"][0]["id"]
    actor = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&with_cast=#{actor_id}"
    movies = JSON.parse(actor)["results"]
    movies.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def sort_by_genre
    # c = serialize(@data)
    response = RestClient.get "#{@base_url}genre/movie/list?api_key=#{@key}"
    categories = JSON.parse(response)["genres"]
    genre_id = ""
    categories.each {|category| genre_id = category["id"] if @data == category["name"]}
    genre = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&with_genres=#{genre_id}"
    movies = JSON.parse(genre)["results"]
    movies.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def self.call_movie(id)
    response = RestClient.get "https://api.themoviedb.org/3/movie/#{id}?api_key=#{ENV['TMDB_KEY']}"
    JSON.parse(response)
  end

  def self.call_movie_credits(id)
    response = RestClient.get "https://api.themoviedb.org/3/movie/#{id}/credits?api_key=#{ENV['TMDB_KEY']}"
    JSON.parse(response)
  end

  def self.search(query)
    movie_results = []
    tv_results = []
    person_results = []

    response = RestClient.get "https://api.themoviedb.org/3/search/multi?api_key=#{ENV['TMDB_KEY']}&query=#{query}"
    JSON.parse(response)['results'].each do |result|
      if result['media_type'] == 'person'
        person_results << result
      elsif result['media_type'] == 'movie'
        movie_results << result
      else
        tv_results << result
      end

      person_results.each do |pers|
        if pers['known_for'].is_a? Array
          pers['known_for'].each do |video|
            if video['media_type'] == 'movie'
              movie_results << video
            else
              tv_results << video
            end
          end
        else
          if pers['known_for']['media_type'] == 'movie'
            movie_results << pers['known_for']
          else
            tv_results << pers['known_for']
          end
        end
      end
    end
    {
      movie: movie_results.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse,
      tv: tv_results.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
     }
  end

  def sort_by_duration
    d = serialize(@data)
    response = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&#{d}&vote_count.gte=1"
    duration = JSON.parse(response)["results"]
    duration.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def sort_by_year
    y = serialize(@data)
    response = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&#{y}"
    year = JSON.parse(response)["results"]
    year.reject { |m| m['video'] == true }.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def search_movie
    response = RestClient.get "#{@base_url}search/movie?api_key=#{ENV['TMDB_KEY']}&query=#{@data}"
    JSON.parse(response)['results'].reject { |m| m['video'] == true }.sort_by { |m| m['vote_average'].to_f }.reverse
  end

  def search_person
    response = RestClient.get "#{@base_url}search/person?api_key=#{ENV['TMDB_KEY']}&query=#{@data}"
    JSON.parse(response)['results']
      .map { |p| p['known_for'].reject { |m| m['media_type'] == 'tv' } }.flatten
      .reject { |m| m['video'] == true }
      .sort_by { |m| m['vote_average'].to_f }
      .reverse
  end
  def self.find_trailer(id)
    response = RestClient.get "https://api.themoviedb.org/3/movie/#{id}/videos?api_key=#{ENV['TMDB_KEY']}"
    if JSON.parse(response)['results'].blank?
      '550'
    else
      p JSON.parse(response)['results'][0]["key"]
    end
  end
end

