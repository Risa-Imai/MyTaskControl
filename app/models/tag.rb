class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
end
