class BookmarkPolicy < ModelWithScopePolicy
  class Scope < Scope
    def resolve
      if user.administrator?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    true
  end

  def manage?
    user.administrator? || record.user_id == user.id
  end
end
