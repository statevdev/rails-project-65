class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
    authorize [:admin, @bulletins]
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize [:admin, @bulletin]
  end

  def destroy
    @bulletin = Bulletin.find(params[:id])
    authorize [:admin, @bulletin]

    @bulletin.destroy!
    redirect_to admin_bulletins_path
  end
end