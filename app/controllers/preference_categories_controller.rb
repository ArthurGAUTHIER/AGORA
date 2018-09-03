class PreferenceCategoriesController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @preference_category = PreferenceCategory.new(user: current_user, category: @category)
    if @preference_category.save
      redirect_to dashboard_path
    else
      render 'dashboard'
    end
  end
end
