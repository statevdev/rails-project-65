# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @bulletins = Bulletin.includes(:category, :user).order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
  end

  def create
    @bulletin = current_user.bulletins.build(bulletins_params)

    if @bulletin.save
      redirect_to @bulletin, notice: t('bulletins.create')
    else
      logger.debug @bulletin.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bulletins_params
    params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
  end
end
