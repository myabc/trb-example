class HospitalPolicy < ModelWithScopePolicy
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

  def manage?
    authenticated? && user_is_privileged?
  end
end
