require 'test_helper'

class PreferenceMoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get preference_moods_create_url
    assert_response :success
  end

end
