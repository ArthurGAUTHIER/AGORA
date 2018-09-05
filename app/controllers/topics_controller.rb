class TopicsController < ApplicationController
  before_action :set_params, only: [:show, :destroy]

  def index
    @topics = Topic.all
  end

  def show
  end

  def create
    @topic = Topic.create(topic_params)
    @topic.user = current_user
    if @topic.valid?
      redirect_to topics_path
    else
      render :index
    end
  end

  def destroy
    @topic.destroy
    redirect_to topics_path
  end

  private

  def set_params
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :user)
  end
end
