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

  def serialize(args)
    #here we put some symbol for answer from the form
    # :d for director, :a for actor, :c for category
    array = []
    args.each do |k, v|
      if k == :d
        array << "#{v.gsub(' ', '%20')}"
      elsif k == :a
        array << "#{v.gsub(' ', '%20')}"
      elsif k == :c
        array << "#{v.gsub(' ', ', ')}"
      else
        array << "#{k}=#{v}"
      end
    end
    array.join('&')
  end

  def sort_by_director
    d = serialize(@data)
    response = RestClient.get "https://api.tmdb.org/3/search/person?api_key=#{@key}&query=#{d}"
    director_id = JSON.parse(response)["results"][0]["id"]
    director = RestClient.get "#{@base_url}person/#{director_id}/movie_credits?api_key=#{@key}"
    movies = JSON.parse(director)["cast"]
    movies.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def sort_by_actor
    a = serialize(@data)
    response = RestClient.get "https://api.tmdb.org/3/search/person?api_key=#{@key}&query=#{a}"
    actor_id = JSON.parse(response)["results"][0]["id"]
    actor = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&with_cast=#{actor_id}"
    movies = JSON.parse(actor)["results"]
    movies.sort_by{|h| h['vote_average'].to_f}.reverse
  end

    def sort_by_genre
    c = serialize(@data)
    response = RestClient.get "#{@base_url}genre/movie/list?api_key=#{@key}"
    categories = JSON.parse(response)["genres"]
    genre_id = ""
    categories.each {|category| genre_id = category["id"] if c == category["name"]}
    genre = RestClient.get "#{@base_url}discover/movie?api_key=#{@key}&with_genres=#{genre_id}"
    movies = JSON.parse(genre)["results"]
    movies.sort_by{|h| h['vote_average'].to_f}.reverse
  end

  def self.call_movie(id)
    response = RestClient.get "https://api.themoviedb.org/3/movie/#{id}?api_key=#{ENV['TMDB_KEY']}"
    JSON.parse(response)
  end

  def self.call_movie_credits(id)
    response = RestClient.get "https://api.themoviedb.org/3/movie/#{id}/credits?api_key=#{ENV['TMDB_KEY']}"
    JSON.parse(response)
  end
end

