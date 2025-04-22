# frozen_string_literal: true

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
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
  end
end