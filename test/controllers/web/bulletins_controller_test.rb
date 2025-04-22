# frozen_string_literal: true

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)

    @bulletin = bulletins.sample

    @bulletin_attrs = {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraphs(number: 5).join,
      user_id: @user.id,
      category_id: categories.sample.id,
      image: fixture_file_upload('image.jpeg', 'image/jpeg')
    }
  end

  test 'get all bulletins for guest' do
    get root_path
    assert_response :success
  end

  test 'show one bulletin for guest' do
    get bulletin_path(@bulletin)
    assert_response :success
  end

  test 'get bulletin form for guest' do
    get new_bulletin_path
    assert_redirected_to root_path

    assert_equal 'Please, sign in.', flash[:alert]
  end

  test 'get created bulletin for guest' do
    post bulletins_path, params: { bulletin: @bulletin_attrs }

    assert_redirected_to root_path
    assert_equal 'Please, sign in.', flash[:alert]
  end

  test 'get all bulletins for sign in user' do
    sign_in(@user)
    get root_path
    assert_response :success
  end

  test 'show one bulletin for sign in user' do
    sign_in(@user)
    get bulletin_path(@bulletin)
    assert_response :success
  end

  test 'get bulletin form for sign in user' do
    sign_in(@user)
    get new_bulletin_path
    assert_response :success
  end

  test 'get created bulletin for sign in user' do
    sign_in(@user)

    post bulletins_path, params: { bulletin: @bulletin_attrs }

    assert_redirected_to bulletin_path(Bulletin.last)
    assert_equal 'Success!', flash[:notice]
  end
end