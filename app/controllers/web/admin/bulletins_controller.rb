# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  before_action :set_bulletin, except: %i[index under_moderation]

  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
    authorize [:admin, @bulletins]
  end

  def under_moderation
    @bulletins = Bulletin.under_moderation.includes(:category, :user).order(created_at: :desc)
    authorize [:admin, @bulletins]
  end

  def destroy
    @bulletin.destroy!
    redirect_to admin_bulletins_path, notice: t('.destroyed')
  end

  def publish
    @bulletin.publish!
    redirect_to admin_root_path, notice: t('.success')
  end

  def reject
    @bulletin.reject!
    redirect_to admin_root_path, notice: t('.success')
  end

  def archive
    @bulletin.archive!
    redirect_back(fallback_location: admin_bulletins_path, notice: t('.success'))
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
