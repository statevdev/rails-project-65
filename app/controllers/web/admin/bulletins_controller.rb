# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  before_action :set_bulletin, except: %i[index under_moderation]

  def index
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.includes(:category, :user).order(created_at: :desc).page(params[:page])
    authorize [:admin, @bulletins]
  end

  def under_moderation
    @bulletins = Bulletin.under_moderation.includes(:category, :user).order(created_at: :desc).page(params[:page])
    authorize [:admin, @bulletins]
  end

  def destroy
    @bulletin.destroy!
    redirect_to admin_bulletins_path, notice: t('.destroyed')
  end

  def publish
    if @bulletin.may_publish?
      @bulletin.publish!

      redirect_to admin_root_path, notice: t('.success')
    else
      redirect_to admin_root_path, notice: t('failure')
    end
  end

  def reject
    if @bulletin.may_reject?
      @bulletin.reject!

      redirect_to admin_root_path, notice: t('.success')
    else
      redirect_to admin_root_path, notice: t('failure')
    end
  end

  def archive
    if @bulletin.may_archive?
      @bulletin.archive!

      redirect_back(fallback_location: admin_bulletins_path, notice: t('.success'))
    else
      redirect_back(fallback_location: admin_bulletins_path, notice: t('failure'))
    end
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
    authorize [:admin, @bulletin]
  end

  def bulletins_params
    params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
  end
end
