class UsersController < ApplicationController
  def show
    @media_count = media_count
    @time_spent = time_spent
    @average_duration = average_duration
    @favorite_category = favorite('categories')
    @favorite_actor = favorite('actors')
    @favorite_director = favorite('directors')
    @favorite_studio = favorite('studio')
  end

  private

  def user_params
    params.require(:article).permit(:alias, :email, :photo)
  end

  def media_count
    return Library.all.where(already_watched: true, user: current_user).count
  end

  def time_spent
    count = 0
    Library.all.where(already_watched: true, user: current_user).each do |instance|
      count += instance.medium.duration
    end
    return count
  end

  def average_duration
    avg_duration = 0
    total_duration = 0
    Library.all.where(already_watched: true, user: current_user).each do |instance|
      total_duration += instance.medium.duration
      avg_duration = total_duration / media_count
    end
    return avg_duration
  end

  def favorite(type)
    name_tab = Library.all.where(already_watched: true, user: current_user).map do |instance|
      if type == 'categories'
        instance.medium.send(type.to_sym).map { |element| element.name }
      elsif type == 'actors' || type == 'directors'
        instance.medium.send(type.to_sym).map { |element| element.full_name }
       else
        instance.medium.send(type.to_sym).name
      end
    end
    name_uniq = name_tab.flatten.uniq
    name_count = name_uniq.map do |occurence|
      name_tab.flatten.count(occurence)
    end
    value_max = name_count.each_with_index.max[1]
    return name_uniq[value_max]
  end
end


