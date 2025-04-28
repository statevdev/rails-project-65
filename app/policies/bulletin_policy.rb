# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || user&.admin? || record.user_id == user&.id
  end

  def new?
    user
  end

  def create?
    user
  end

  def edit?
    user&.admin? || record.user_id == user&.id
  end

  def update?
    user&.admin? || record.user_id == user&.id
  end

  def to_moderate?
    user&.admin? || record.user_id == user&.id
  end

  def archive?
    user&.admin? || record.user_id == user&.id
  end
end
