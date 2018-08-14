require_dependency 'employee/contract/update'

class Employee::Update < Trailblazer::Operation
  extend Contract::DSL
  extend Representer::DSL

  private

  def process_employee; end

  def notify_author_reported; end

  def notify_author_current; end

  def status_changed_to
    model.previous_changes.fetch('status', []).last
  end
end
