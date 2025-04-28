# frozen_string_literal: true

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @published_bulletin = bulletins(:red_bus)
    @draft_bulletin = bulletins(:blue_bike)

    @bulletin_attrs = {
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraphs(number: 5).join,
      user_id: @user.id,
      category_id: categories.sample.id,
      image: fixture_file_upload('image.jpeg', 'image/jpeg')
    }
  end

  test 'get all bulletins' do
    sign_in @user
    get root_path
    assert_response :success
  end

  test 'show bulletin' do
    sign_in @user
    get bulletin_path(@published_bulletin)
    assert_response :success
  end

  test 'get bulletin form' do
    sign_in(@user)
    get new_bulletin_path
    assert_response :success
  end

  test 'get created bulletin' do
    sign_in(@user)

    post bulletins_path, params: { bulletin: @bulletin_attrs }

    bulletin = Bulletin.find_by(title: @bulletin_attrs[:title])

    assert bulletin
    assert_redirected_to bulletin_path(Bulletin.last)
    assert_equal 'Success!', flash[:notice]
  end

  test 'get edit bulletin form' do
    sign_in(@user)

    get edit_bulletin_path(@published_bulletin)
    assert_response :success
    assert_select 'h2', 'Edit bulletin'
  end

  test 'get updated bulletin' do
    sign_in(@user)

    patch bulletin_path(@published_bulletin), params: { bulletin: @bulletin_attrs }

    @published_bulletin.reload

    assert_redirected_to profile_path
    assert_equal 'Success!', flash[:notice]
    assert_equal @published_bulletin.title, @bulletin_attrs[:title]
  end

  test 'to moderate bulletin' do
    sign_in(@user)
    patch to_moderate_bulletin_path(@draft_bulletin)

    @draft_bulletin.reload

    assert @draft_bulletin.under_moderation?
    assert_redirected_to profile_path
    assert_equal 'Submitted for moderation!', flash[:notice]
  end

  test 'archive bulletin' do
    sign_in(@user)
    patch archive_bulletin_path(@draft_bulletin)

    @draft_bulletin.reload

    assert @draft_bulletin.archived?
    assert_redirected_to profile_path
    assert_equal 'Bulletin is archived!', flash[:notice]
  end

  test 'not authorized' do
    get new_bulletin_path
    assert_redirected_to root_path

    assert_equal 'Please, sign in.', flash[:alert]
  end
end
