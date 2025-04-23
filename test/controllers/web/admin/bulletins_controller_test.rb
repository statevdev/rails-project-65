# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @bulletin = bulletins.sample
  end

  test 'get all bulletins for admin' do
    sign_in @admin
    get admin_bulletins_path
    assert_response :success
    assert_select 'h2', 'Bulletins'
  end

  test 'destroy one bulletin by admin' do
    sign_in @admin
    delete admin_bulletin_path(@bulletin)

    assert_not Bulletin.exists?(@bulletin.id)
    assert_redirected_to admin_bulletins_path
    assert_equal 'The bulletin has been successfully deleted.', flash[:notice]
  end

  test 'not authorize action' do
    @user = users(:user)
    sign_in @user
    get admin_bulletins_path

    assert_redirected_to root_path
    assert_equal 'This section is for admins only.', flash[:alert]
  end
end
