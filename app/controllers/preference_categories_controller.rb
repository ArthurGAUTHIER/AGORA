class PreferenceCategoriesController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @preference_category = PreferenceCategory.create(user: current_user, category: @category)
    if @preference_category.valid?
      redirect_to dashboard_path
    else
      render 'dashboard'
    end
  end

  def destroy
    @preference_category = PreferenceCategory.find(params[:id])
    @preference_category.destroy
    redirect_to dashboard_path
  end
end
