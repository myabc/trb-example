class ApplicationPolicy
  class_attribute :allow_unauthenticated
  self.allow_unauthenticated = false

  attr_reader :user, :resource

  def initialize(user, resource)
    unless user || self.class.allow_unauthenticated
      raise Pundit::NotAuthorizedError, 'must be logged in'
    end

    @user     = user
    @resource = resource
  end

  def authenticated?
    !!user
  end

  def manage?
    user.administrator?
  end

  def maintain?
    manage?
  end

  def index?
    maintain?
  end

  def show?
    maintain?
  end

  def create?
    manage?
  end

  def new?
    create?
  end

  def update?
    maintain?
  end

  def edit?
    update?
  end

  def destroy?
    manage?
  end

  def user_is_privileged?
    user.admin?
  end
end
