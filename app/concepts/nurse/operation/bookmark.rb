require_dependency 'employee/operation/bookmark'

class Nurse::Bookmark < ::Employee::Bookmark
  model  Nurse, :find
  policy NursePolicy, :bookmark?
end
