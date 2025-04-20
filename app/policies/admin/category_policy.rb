# frozen_string_literal: true

class Admin::CategoryPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def show?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end
end