class Task < ApplicationRecord
  belongs_to :customer
  has_many :task_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title, presence: true

  #進捗ステータス
  enum progress_status: { notReady: 0, Ready: 1, Doing: 2, Done: 3 }
  
  #引数で渡された会員idがFavoritesテーブル内に存在(exist?)するか
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  
end
