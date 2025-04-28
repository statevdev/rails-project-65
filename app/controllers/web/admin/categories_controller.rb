# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.includes(:bulletins).order(created_at: :desc).page(params[:page])
    # authorize [:admin, @categories]
  end

  def new
    @category = Category.new
    # authorize [:admin, @category]
  end

  def edit; end

  def create
    @category = Category.new(categories_params)
    # authorize [:admin, @category]

    if @category.save
      redirect_to %i[admin categories], notice: t('success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(categories_params)
      redirect_to %i[admin categories], notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.bulletins.exists?
      flash[:alert] = t('.destroy_has_bulletins')
    else
      @category.destroy!
      flash[:notice] = t('.destroyed')
    end
    redirect_to [:admin, @category]
  end

  private

  def set_category
    @category = Category.find(params[:id])
    # authorize [:admin, @category]
  end

  def categories_params
    params.require(:category).permit(:name)
  end
end
