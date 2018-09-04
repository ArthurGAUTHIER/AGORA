# require 'csv'

# BOOL = [false, true]

# puts 'Set CSV options...'
# csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
# filepath    = 'db/IMDB-Movie-Data.csv'

# puts 'Create blank Studio...'
# studio = Studio.find_by(name: 'test')
# if studio.nil?
#   studio = Studio.create!(name: 'test')
# end

# puts 'Begin CSV parsing...'
# CSV.foreach(filepath, csv_options) do |row|

#   categories = [];
#   row['Genre'].split(',').each do |genre|
#     category = Category.find_by(name: genre)
#     if category.nil?
#       category = Category.create!(
#         name: genre
#         )
#     end
#     categories << category
#   end

#   actors = []
#   row['Actors'].split(',').each do |actor_full_name|
#     names = actor_full_name.split(' ')
#     if names.length == 1
#       names = [names.first, names.first]
#     else
#       if names.length > 2
#         names = [names[0..-2].join(' '), names.last]
#       end
#     end

#     first_name = names[0]
#     last_name = names[1]

#     actor = nil
#     Actor.where(last_name: last_name).each do |actor_family|
#       if actor_family.first_name == first_name
#         actor = actor_family
#       end
#     end

#     if actor.nil?
#       actor = Actor.create!(
#         first_name: first_name,
#         last_name: last_name
#         )
#     end
#     actors << actor
#   end

#   names = row['Director'].split(' ')

#   if names.length == 1
#     names = [names.first, names.first]
#   else
#     if names.length > 2
#       names = [names[0..-2].join(' '), names.last]
#     end
#   end

#   first_name = names[0]
#   last_name = names[1]

#   director = nil
#   Director.where(last_name: last_name).each do |director_family|
#     if director_family.first_name == first_name
#       director = director_family
#     end
#   end

#   if director.nil?
#     director = Director.create!(
#       first_name: first_name,
#       last_name: last_name
#       )
#   end

#   medium = Medium.find_by(title: row['Title'])
#   if medium.nil?
#     medium = Medium.create!(
#       title: row['Title'],
#       synopsys: row['Description'],
#       duration: row['Runtime (Minutes)'].to_i,
#       year: row['Year'].to_i,
#       press_rating: row['Metascore'].to_f / 10,
#       audience_rating: row['Rating'].to_f,
#       studio: studio
#       )
#     medium.directors = [director]
#     medium.actors = actors
#     medium.categories = categories
#   end
# end
# puts 'CSV parsing done...'

# users = []
# puts 'Create users...'
# 5.times do |i|
#   user = User.create!(
#     email: "user#{i}@gmail.com",
#     password: '123456',
#     password_confirmation: '123456',
#     alias: 'random#{i}'
#     )
#   users << user
# end

# puts 'Create reviews...'
# 2.times do |i|
#   Review.create!(
#     title: "Super #{i}",
#     description: "C dingue ce truc #{'+' * i}",
#     user: User.all.sample,
#     medium: Medium.all.sample
#     )
# end

# puts 'Create libraries...'
# 5.times do |i|
#   Library.create!(
#     already_watched: BOOL.sample,
#     watch_later: BOOL.sample,
#     blacklist: BOOL.sample,
#     user: User.first,
#     medium: Medium.all.sample
#     )
# end

# puts 'Seed generated...'
