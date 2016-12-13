class EmployeePolicy < ModelWithScopePolicy
  class Scope < Scope
    self.allow_unauthenticated = true

    def resolve
      if user && user_is_privileged?
        scope.all
      elsif user
        scope.where(author_id: user.id).or(scope.current)
      else
        scope.current
      end
    end
  end

  alias employee record
  delegate :department, to: :employee

  def manage?
    user_is_privileged?
  end

  def create?
    true
  end

  def update?
    user_is_privileged? ||
      user_is_employee_author?
  end

  def destroy?
    user_is_privileged? ||
      user_is_employee_author?
  end

  def report?
    user && show?
  end

  def bookmark?
    user && show?
  end

  def unbookmark?
    user && show?
  end

  def republish?
    user_is_privileged?
  end

  private

  def user_is_employee_author?
    employee.author_id == user.id
  end
end
