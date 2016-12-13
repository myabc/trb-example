class ClinicPolicy < ModelWithScopePolicy
  self.allow_unauthenticated = true

  class Scope < Scope
    self.allow_unauthenticated = true

    def resolve
      if user && user_is_privileged?
        scope.all
      else
        scope.joins(:department).merge(Department.published)
      end
    end
  end

  alias clinic record
  delegate :department, to: :clinic

  def create?
    user_is_author? ||
      user_is_privileged?
  end

  def update?
    user_is_author? ||
      user_is_privileged?
  end

  def destroy?
    user_is_author? &&
      user_is_exclusive_employee_author? ||
      user_is_privileged?
  end

  private

  def user_is_exclusive_employee_author?
    !clinic.doctors.where.not(author_id: user.id).exists? &&
      !clinic.nurses.where.not(author_id: user.id).exists?
  end

  def user_is_author?
    user && clinic.author_id == user.id
  end
end
