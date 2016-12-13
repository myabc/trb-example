class Department::Delete < Trailblazer::Operation
  include Policy
  policy DepartmentPolicy, :destroy?

  def model!(params)
    Department.friendly.find(params[:id])
  end

  def process(_params)
    model.destroy!
  end
end
