class TaskComment < ApplicationRecord
  belongs_to :customer
  belongs_to :task

  validates :comment, presence: true, length: { maximum: 140 }

  # コメント一覧を降順で表示する為のメソッド
  scope :latest, -> { order(created_at: :desc) }
end