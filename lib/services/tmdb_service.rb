
class TmdbService
  def initialize(words)
    @words = words
    Tmdb::Api.key("#{ENV['TMDB_KEY']}")
    Tmdb::Api.language("fr")
  end
  def call
    # Tmdb::Discover.movie("${@words}")
    Tmdb::Discover.movie
  end
end

