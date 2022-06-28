class TaskTag < ApplicationRecord
  belongs_to :task
  belongs_to :tag

  # タグを降順に並べ替える
  def self.tag_count
    group(:tag_id).order("count(task_id) desc")
  end
end
