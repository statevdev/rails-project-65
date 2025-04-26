# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :set_bulletin, except: %i[index new create]

  def index
    @bulletins = Bulletin.published.includes(:category, :user).order(created_at: :desc)
    authorize @bulletins
  end

  def show; end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def edit; end

  def create
    @bulletin = current_user.bulletins.build(bulletins_params) if current_user
    authorize Bulletin

    if @bulletin.save
      redirect_to @bulletin, notice: t('success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bulletin.update(bulletins_params)
      redirect_to profile_path, notice: t('success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def to_moderate
    @bulletin.to_moderate!
    redirect_to profile_path, notice: t('.success')
  end

  def archive
    @bulletin.archive!
    redirect_to profile_path, notice: t('.success')
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def bulletins_params
    params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
  end
end
