# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, only: %i[new]

  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  private

  def bulletins_params
    params.require(:bulletin).permit(:title, :description, :user_id, :category_id)
  end
end
