class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.includes(:bulletins).order(created_at: :desc)
    authorize [:admin, @categories]
  end

  def new
    @category = Category.new
    authorize [:admin, @category]
  end

  def create
    @category = Category.new(categories_params)
    authorize [:admin, @category]

    if @category.save
      redirect_to [:admin, :categories], notice: t('success')
    else
      flash[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(categories_params)
      redirect_to [:admin, :categories], notice: t('.updated')
    else
      flash[:alert] = t('fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.bulletins.exists?
      flash[:alert] = t('.destroy_has_bulletins')
      redirect_to [:admin, @category]
    else
      @category.destroy!
      flash[:notice] = t('.destroyed')
      redirect_to [:admin, @category]
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
    authorize [:admin, @category]
  end

  def categories_params
    params.require(:category).permit(:name)
  end
end