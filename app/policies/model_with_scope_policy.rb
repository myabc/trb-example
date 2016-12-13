class ModelWithScopePolicy < ApplicationPolicy
  attr_reader :model_or_instance

  def initialize(user, model_or_instance)
    unless user || self.class.allow_unauthenticated
      raise Pundit::NotAuthorizedError, 'must be logged in'
    end

    @user               = user
    @model_or_instance  = model_or_instance
  end

  def record
    @record ||= find_record
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private

  def find_record
    if model_or_instance.respond_to?(:id) ||
       model_or_instance.is_a?(ActiveRecord::Base) ||
       model_or_instance.is_a?(ActiveModel::Model)
      model_or_instance
    else
      model_or_instance.new
    end
  end

  class Scope
    class_attribute :allow_unauthenticated
    self.allow_unauthenticated = false

    attr_reader :user, :scope

    def initialize(user, scope)
      unless user || self.class.allow_unauthenticated
        raise Pundit::NotAuthorizedError, 'must be logged in'
      end

      @user  = user
      @scope = scope
    end

    def resolve
      if user.administrator?
        scope.all
      else
        scope.none
      end
    end

    def user_is_privileged?
      true # TODO: implement me
    end
  end
end
