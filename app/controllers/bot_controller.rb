require 'recastai'

class BotController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def send_message
    client = RecastAI::Client.new("7390b5ef0c620284e447c95d5da1060a")
    request = RecastAI::Request.new("7390b5ef0c620284e447c95d5da1060a")
    build = RecastAI::Build.new("7390b5ef0c620284e447c95d5da1060a")
    # client.request.analyse_text('Hi')
    # connect = client.connect

    res = build.dialog({type: "text", content: params[:message][:content]}, params[:conversation_id])

    render json: { response: res }
  end

end
