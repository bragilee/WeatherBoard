require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get showLocation" do
    get :showLocation
    assert_response :success
  end

  test "should get showPostcode" do
    get :showPostcode
    assert_response :success
  end

end
