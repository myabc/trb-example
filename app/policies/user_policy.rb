class UserPolicy < ModelWithScopePolicy
  class Scope < Scope
    def resolve
      if user_is_privileged?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def manage?
    user_is_privileged?
  end

  def maintain?
    record.id == user.id || manage?
  end

  def destroy?
    user.patient? && record.id == user.id || manage?
  end

  def show_profile?
    true
  end
end
