class UsersController < ApplicationController
  def user_params
  params.require(:article).permit(:alias, :email, :photo)
  end
end
