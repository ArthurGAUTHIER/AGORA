
class TmdbService
  def initialize(words)
    @words = words.strip.gsub(' ', '+')
  end
  def call
    Tmdb::Api.key("#{ENV['TMDB_KEY']}")
    Tmdb::Api.language("fr")
    # Tmdb::Discover.movie("${@words}")
    Tmdb::Search.movies("${@words}")

  end
end

