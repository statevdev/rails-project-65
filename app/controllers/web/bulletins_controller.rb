# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
    authorize @bulletins
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def create
    @bulletin = current_user.bulletins.build(bulletins_params) if current_user
    authorize Bulletin

    if @bulletin.save
      redirect_to @bulletin, notice: t('success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bulletins_params
    params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
  end
end
