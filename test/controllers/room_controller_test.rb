require "test_helper"

class RoomControllerTest < ActionDispatch::IntegrationTest
  test "should get message" do
    get room_message_url
    assert_response :success
  end
end
