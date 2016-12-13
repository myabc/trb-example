class DepartmentPolicy < ModelWithScopePolicy
  self.allow_unauthenticated = true

  class Scope < Scope
    self.allow_unauthenticated = true

    def resolve
      if user && user_is_privileged?
        scope.all
      else
        scope.published
      end
    end
  end

  alias department record

  def manage?
    return false unless authenticated?

    department.creator_id == user.id ||
      user_is_privileged?
  end

  def create?
    authenticated?
  end

  def destroy?
    return false unless authenticated?

    department.creator_id == user.id && (
       employees_empty? ||
       (user_is_exclusive_clinic_author? &&
         user_is_exclusive_employee_author?)) ||
      user_is_privileged?
  end

  def download?
    manage?
  end

  private

  def user_is_exclusive_clinic_author?
    !department.clinics.where.not(author_id: user.id).exists?
  end

  def employees_empty?
    !department.doctors.exists? && !department.nurses.exists?
  end

  def user_is_exclusive_employee_author?
    !department.doctors.where.not(author_id: user.id).exists? &&
      !department.nurses.where.not(author_id: user.id).exists?
  end
end
