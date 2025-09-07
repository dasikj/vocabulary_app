require "test_helper"

class VocabulariesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vocabularies_new_url
    assert_response :success
  end

  test "should get index" do
    get vocabularies_index_url
    assert_response :success
  end
end
