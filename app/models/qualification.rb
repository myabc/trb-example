class Qualification < ActiveRecord::Base
  belongs_to :nurse, foreign_key: :employee_id
end
