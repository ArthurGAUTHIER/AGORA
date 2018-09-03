require 'test_helper'

class PreferenceCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get preference_categories_create_url
    assert_response :success
  end

end
