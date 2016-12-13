module Commenting
  class ThreadPolicy < ModelWithScopePolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def create?
      true
    end

    def update?
      user_is_privileged?
    end

    def destroy?
      user_is_privileged?
    end
  end
end
