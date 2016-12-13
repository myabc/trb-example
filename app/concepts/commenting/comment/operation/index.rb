class Commenting::Comment::Index < Trailblazer::Operation
  include Representer
  representer V1::CommentsRepresenter

  def model!(params)
    Commenting::CommentPolicy::Scope.new(
      params.fetch(:current_user),
      find_employee(params).comments
    ).resolve.comment_tree
  end

  def process(_params); end

  def to_json(*)
    super(user_options: { include_replies: true })
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
