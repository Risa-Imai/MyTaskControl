class TaskComment < ApplicationRecord
    belongs_to :customer
    belongs_to :task

    validates :comment, presence: true, length: {maximum: 140}
end
