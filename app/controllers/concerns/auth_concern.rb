# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def user_not_authorized
    authenticate_user!
    return unless signed_in?

    authenticate_admin!
  end

  def authenticate_user!
    return if signed_in?

    flash[:alert] = t('not_auth')
    redirect_to root_path
  end

  def authenticate_admin!
    return if current_user.admin?

    flash[:alert] = t('not_auth_admin')
    redirect_to root_path
  end

  def sign_in(user)
    session[:user_id] = user&.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
