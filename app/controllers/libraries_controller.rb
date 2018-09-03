class LibrariesController < ApplicationController
  def create
    not_in_library = true
    current_user.libraries.each do |library|
      medium = Medium.find(params[:medium_id])
      if library.medium == medium
        not_in_library = false
        library.update(
          blacklist: params['blacklist'] == 'true'
          already_watched: params['already_watched'] == 'true'
          watch_later: params['watch_later'] == 'true'
          )
      end
    end
    if not_in_library == true
      Library.create(
        user: current_user
        medium: Medium.find(params[:medium_id])
        blacklist: params['blacklist'] == 'true'
        already_watched: params['already_watched'] == 'true'
        watch_later: params['watch_later'] == 'true'
      )
    end
  end
end
