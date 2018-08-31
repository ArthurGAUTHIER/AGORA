# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

BOOL = [false, true]

puts 'Set CSV options...'
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/IMDB-Movie-Data.csv'

puts 'Create blank Studio...'
studio = Studio.find_by(name: 'test')
if studio.nil?
  studio = Studio.create!(name: 'test')
end

puts 'Begin CSV parsing...'
CSV.foreach(filepath, csv_options) do |row|

  categories = [];
  row['Genre'].split(',').each do |genre|
    category = Category.find_by(name: genre)
    if category.nil?
      category = Category.create!(
        name: genre
        )
    end
    categories << category
  end

  actors = []
  row['Actors'].split(',').each do |actor_full_name|
    names = actor_full_name.split(' ')
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
      end
    end

    if actor.nil?
      actor = Actor.create!(
        first_name: first_name,
        last_name: last_name
        )
    end
    actors << actor
  end

  names = row['Director'].split(' ')

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
    end
  end

  if director.nil?
    director = Director.create!(
      first_name: first_name,
      last_name: last_name
      )
  end

  medium = Medium.find_by(title: row['Title'])
  if medium.nil?
    medium = Medium.create!(
      title: row['Title'],
      synopsys: row['Description'],
      duration: row['Runtime (Minutes)'].to_i,
      year: row['Year'].to_i,
      press_rating: row['Metascore'].to_f / 10,
      audience_rating: row['Rating'].to_f,
      studio: studio
      )
    medium.directors = [director]
    medium.actors = actors
    medium.categories = categories
  end
end
puts 'CSV parsing done...'

puts 'Create reviews...'
reviews = []
2.times do |i|
  reviews << Review.create!(
    title: "Super #{i}",
    description: "C dingue ce truc #{'+' * i}"
    )
end

users = []
puts 'Create users...'
5.times do |i|
  user = User.create!(
    email: 'user' << i,
    password: '123456',
    password_confirmation: '123456',
    alias: 'random' << i,
    reviews: reviews
    )
  user.reviews = reviews
end

puts 'Create libraries...'
5.times do |i|
  library = Library.create!(
    already_watched: BOOL.sample,
    watch_later: BOOL.sample,
    blacklist: BOOL.sample
    )
  library.user = User.all.sample
  library.media = Medium.all.sample
end

puts 'Seed generated...'
