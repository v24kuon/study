require 'test_helper'

class ConversionsControllerTest < ActionDispatch::IntegrationTest
  test "should get ocr" do
    get conversions_ocr_url
    assert_response :success
  end

end
