# frozen_string_literal: true

class Web::Profile::BulletinsControllerTest < ActionDispatch::IntegrationTest
  test 'get profile' do
    @user = users(:user)

    sign_in @user 

    get profile_path

    assert_response :success
    assert_select 'h2', 'My bulletins'
  end
end
