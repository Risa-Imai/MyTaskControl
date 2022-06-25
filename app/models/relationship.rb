class Relationship < ApplicationRecord
  # class_name: "Customer"でCustomerモデルを参照
  belongs_to :follower, class_name: "Customer"
  belongs_to :followed, class_name: "Customer"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
end
