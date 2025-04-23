# frozen_string_literal: true

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @category = categories.sample
    @category_without_bulletins = categories(:without_bulletins)
    @category_attrs = { name: Faker::Lorem.sentence }
  end

  test 'get all categories for admin' do
    sign_in @admin
    get admin_categories_path
    assert_response :success
    assert_select 'h2', 'Categories'
  end

  test 'get category form for admin' do
    sign_in @admin
    get new_admin_category_path
    assert_response :success
  end

  test 'get created category for admin' do
    sign_in @admin
    post admin_categories_path, params: { category: @category_attrs }

    assert_redirected_to admin_categories_path
    assert_equal 'Success!', flash[:notice]

    created_category = Category.find_by(@category_attrs)

    assert created_category
  end

  test 'get edit category form for admin' do
    sign_in @admin
    get edit_admin_category_path(@category)
    assert_response :success
    assert_select 'h2', 'Edit the category'
  end

  test 'get updated category for admin' do
    sign_in @admin
    patch admin_category_path(@category), params: { category: @category_attrs }

    @category.reload

    assert_redirected_to admin_categories_path
    assert_equal 'Successfully updated!', flash[:notice]
    assert_equal @category.name, @category_attrs[:name]
  end

  test 'destroy category related with bulletins by admin' do
    sign_in @admin
    delete admin_category_path(@category)

    assert Category.exists?(@category.id)
    assert_equal 'This category has related bulletins.', flash[:alert]
  end

  test 'destroy category without bulletins by admin' do
    sign_in @admin
    delete admin_category_path(@category_without_bulletins)

    assert_not Category.exists?(@category_without_bulletins.id)
    assert_redirected_to admin_categories_path
    assert_equal 'The category has been successfully deleted.', flash[:notice]
  end

  test 'not authorize action' do
    @user = users(:user)
    sign_in @user
    get admin_categories_path

    assert_redirected_to root_path
    assert_equal 'This section is for admins only.', flash[:alert]
  end
end
