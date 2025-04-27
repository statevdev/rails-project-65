# frozen_string_literal: true

class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    raise Pundit::NotAuthorizedError unless current_user

    @q = current_user.bulletins.ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
  end
end
