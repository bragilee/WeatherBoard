require 'test_helper'

class PredictionControllerTest < ActionController::TestCase
  test "should get showLatLong" do
    get :showLatLong
    assert_response :success
  end

  test "should get showPostcode" do
    get :showPostcode
    assert_response :success
  end

end
