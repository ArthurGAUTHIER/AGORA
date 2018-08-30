require "json"
require "rest-client"

class ImdbService
  def initialize(data)
    @data = data
    @key = ENV['IMDB_KEY']
    @base_url = 'http://www.omdbapi.com/?apikey='
  end

  def call
    response = RestClient.get "#{@base_url}#{@key}&#{serialize(@data)}"
    data = JSON.parse(response.body)["Search"]
    data.each_with_object([]) do |r, a|
      a << JSON.parse((RestClient.get "#{@base_url}#{@key}&i=#{r['imdbID']}").body)
    end
  end

  def serialize(args)
    array = []
    args.each do |k, v|
      array << "#{k}=#{v}"
    end
    array.join('&')
  end

  def sort_by_rating
    call.sort_by{|h| h['imdbRating'].to_f}.reverse!
  end
end
