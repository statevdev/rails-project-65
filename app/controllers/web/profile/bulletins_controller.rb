# frozen_string_literal: true

class Web::Profile::BulletinsController < Web::Profile::ApplicationController
  def index
    raise Pundit::NotAuthorizedError unless current_user

    @bulletins = current_user.bulletins
  end
end
