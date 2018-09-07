class LibrariesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # data = JSON.parse(request.body.read)
    not_in_library = true

    current_user.libraries.each do |library|
      medium = Medium.find(params[:medium_id])
      if library.medium == medium
        not_in_library = false
        library.update(
          blacklist: params['blacklist'],
          already_watched: params['already_watched'],
          watch_later: params['watch_later']
          )
      end
    end

    if not_in_library == true
      Library.create(
        user: current_user,
        medium: Medium.find(params[:medium_id]),
        blacklist: params['blacklist'],
        already_watched: params['already_watched'],
        watch_later: params['watch_later']
      )
    end

    redirect_back(fallback_location: root_path)
  end
end
