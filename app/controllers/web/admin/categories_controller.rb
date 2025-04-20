class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @categories = Category.includes(:bulletins).order(created_at: :desc)
    authorize [:admin, @categories]
  end

  def show
    @category = Category.find(params[:id])
    authorize [:admin, @category]
  end

  def destroy
    @category = Category.find(params[:id])
    authorize [:admin, @category]

    @category.destroy!
    redirect_to admin_categories_path
  end
end