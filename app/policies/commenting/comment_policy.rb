module Commenting
  class CommentPolicy < ModelWithScopePolicy
    class Scope < Scope
      def resolve
        if user && user_is_privileged?
          scope.all
        else
          scope.where(author_id: user.id).or(scope.published)
        end
      end
    end

    alias comment record

    def manage?
      user_is_privileged?
    end

    def create?
      true
    end

    def update?
      user_is_privileged? || user_is_comment_author?
    end

    def destroy?
      user_is_privileged? || user_is_comment_author?
    end

    def report?
      show?
    end

    def republish?
      user_is_privileged?
    end

    private

    def user_is_comment_author?
      comment.author_id == user.id
    end
  end
end
