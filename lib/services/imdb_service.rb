require 'open-uri'
require 'nokogiri'
require "json"
require "rest-client"

class ImdbService
  def initialize(title)
    @title = title.strip.gsub(' ', '+')
  end
  def call
    response = RestClient.get "http://www.omdbapi.com/?apikey=#{ENV['IMDB_KEY']}&t=#{@title}"
    JSON.parse(response)
  end
end
