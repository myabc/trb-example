class Commenting::Comment::Index < Trailblazer::Operation
  step :model!

  extend Representer::DSL
  representer :serializer, V1::CommentsRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = Commenting::CommentPolicy::Scope.new(
      current_user,
      find_employee(params).comments
    ).resolve.comment_tree
  end

  private

  def find_employee(params)
    if params[:doctor_id]
      Doctor.find(params[:doctor_id])
    elsif params[:nurse_id]
      Nurse.find(params[:nurse_id])
    else
      raise ArgumentError
    end
  end
end
