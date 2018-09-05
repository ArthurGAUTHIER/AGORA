class LibrariesController < ApplicationController
  def create
    data = JSON.parse(request.body.read)
    not_in_library = true

    current_user.libraries.each do |library|
      medium = Medium.find(params[:medium_id])
      if library.medium == medium
        not_in_library = false
        library.update(
          blacklist: data['blacklist'],
          already_watched: data['already_watched'],
          watch_later: data['watch_later']
          )
      end
    end

    if not_in_library == true
      Library.create(
        user: current_user,
        medium: Medium.find(params[:medium_id]),
        blacklist: data['blacklist'],
        already_watched: data['already_watched'],
        watch_later: data['watch_later']
      )
    end

    head :ok
  end
end
