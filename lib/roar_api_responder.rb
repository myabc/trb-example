class RoarApiResponder < Roar::Rails::Responder
  def initialize(*)
    super
    @options[:location] = nil
  end

  def api_behavior(*args, &block)
    if put? || patch?
      display resource, status: :ok
    else
      super
    end
  end
end
