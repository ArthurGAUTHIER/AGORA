# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'


csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/IMDB-Movie-Data.csv'

movies = [];

CSV.foreach(filepath, csv_options) do |row|
  row['Genre'].split(',').each do |genre|
    categorie = Category.find_by(name: genre)
    if categorie.nil?
      Category.create(
        name: genre
        )
    end
  end

  row['Actors'].split(',').each do |actor|
    names = actor.split(',')

    if names.length > 2
      names = [names[0..(names.length - 1), names.last]]
    end

    first_name = names[0]
    last_name = names[1]

    actor = Actor.find_by(first_name: first_name)
    if actor.nil?
      Actor.create(
        first_name: first_name
        last_name: last_name
        )
    end
  end

  names = row['Director'].split()

    if names.length > 2
      names = [names[0..(names.length - 1), names.last]]
    end

    first_name = names[0]
    last_name = names[1]

  Director.create(
    first_name: first_name
    last_name: last_name
    )

  Medium.create(
    title: row['Title'],
    synopsys: row['Description'],
    duration: row['Runtime (Minutes)'],
    year: row['Year']
    press_rating: row['Metascore'].to_f / 10
    audience_rating: row['Rating']
    )
end
