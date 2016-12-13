require_dependency 'employee/contract/update'

class Employee::Update < Trailblazer::Operation
  include Model
  include Policy
  include Representer
  include Representer::Deserializer::Hash

  def process(params)
    validate(params) do
      contract.save

      process_employee

      case status_changed_to
      when 'current'
        notify_author_current
      end
    end
  end

  private

  def process_employee; end

  def notify_author_reported; end

  def notify_author_current; end

  def status_changed_to
    model.previous_changes.fetch('status', []).last
  end
end
