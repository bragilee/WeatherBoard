require 'test_helper'

class LocationControllerTest < ActionController::TestCase
  test "should get showLocations" do
    get :showLocations
    assert_response :success
  end

end
