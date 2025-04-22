# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      @user = User.find_or_create_by(name: auth.info.name, email: auth.info.email) do |user|
        user.name = auth.info.name
        user.email = auth.info.email
      end

      sign_in @user

      redirect_to root_path, notice: t('sign_in')
    end

    def destroy
      sign_out
      redirect_to root_path, notice: t('sign_out')
    end
  end
end
