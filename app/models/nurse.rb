class Nurse < Employee
  has_many :qualifications, foreign_key: 'employee_id', dependent: :destroy
end
