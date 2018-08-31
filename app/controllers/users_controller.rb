class UsersController < ApplicationController
  def show
  end

  def user_params
    params.require(:article).permit(:alias, :email, :photo)
  end
end
