class VotePolicy < ModelWithScopePolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def manage?
    user.administrator? || record.user_id == user.id
  end

  def show?
    true
  end
end
