class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    @bulletin.destroy!
    redirect_to admin_bulletins_path
  end
end