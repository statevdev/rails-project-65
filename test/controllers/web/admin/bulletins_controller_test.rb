# frozen_string_literal: true

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @under_moderation_bulletin = bulletins(:fennec)
  end

  test 'get all bulletins' do
    sign_in @admin
    get admin_bulletins_path

    assert_response :success
    assert_select 'h2', 'All bulletins'
  end

  test 'get under moderation bulletins' do
    sign_in @admin
    get admin_root_path

    assert_response :success
    assert_select 'h2', 'Bulletins on moderation'
  end

  test 'publish bulletin' do
    sign_in @admin
    patch publish_admin_bulletin_path(@under_moderation_bulletin)

    @under_moderation_bulletin.reload

    assert @under_moderation_bulletin.published?
    assert_redirected_to admin_root_path
    assert_equal 'Bulletin is published!', flash[:notice]
  end

  test 'reject bulletin' do
    sign_in @admin
    patch reject_admin_bulletin_path(@under_moderation_bulletin)

    @under_moderation_bulletin.reload

    assert @under_moderation_bulletin.rejected?
    assert_redirected_to admin_root_path
    assert_equal 'Bulletin is rejected!', flash[:notice]
  end

  test 'archive bulletin' do
    sign_in @admin
    patch archive_admin_bulletin_path(@under_moderation_bulletin)

    @under_moderation_bulletin.reload

    assert @under_moderation_bulletin.archived?
    assert_redirected_to admin_bulletins_path
    assert_equal 'Bulletin is archived!', flash[:notice]
  end

  # test 'not authorize action' do
  #   @user = users(:user)
  #   sign_in @user

  #   get admin_root_path

  #   assert_redirected_to root_path
  #   assert_equal 'This section is for admins only.', flash[:alert]
  # end
end
