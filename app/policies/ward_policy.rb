class WardPolicy < ModelWithScopePolicy
  class Scope < Scope
    self.allow_unauthenticated = true

    def resolve
      if user && user_is_privileged?
        scope.all
      elsif user
        scope.where(creator_id: user.id).not_marked_for_deletion
             .or(scope.published)
      else
        scope.published
      end
    end
  end

  alias ward record
  delegate :department, to: :ward

  def manage?
    user_is_privileged?
  end

  def create?
    true
  end

  def bookmark?
    user && show?
  end

  def unbookmark?
    user && show?
  end

  def update?
    user_is_privileged? ||
      user_is_ward_creator?
  end

  def destroy?
    user_is_privileged? ||
      user_is_ward_creator?
  end

  private

  def user_is_ward_creator?
    ward.creator_id == user.id
  end
end
