require_relative '../../models/model_base'
class Todo < ModelBase
  finalize!
  belongs_to :user
end