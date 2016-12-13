class PatientPolicy < UserPolicy
  def destroy?
    user_is_privileged? ||
      (user.patient? && record.id == user.id)
  end
end
