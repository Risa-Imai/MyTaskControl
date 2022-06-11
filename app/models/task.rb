class Task < ApplicationRecord
  belongs_to :customer
  has_many :task_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags

  validates :title, presence: true
  validates :progress_status, presence: true

  # 進捗ステータス
  enum progress_status: { notReady: 0, Ready: 1, Doing: 2, Done: 3 }

  # 引数で渡された会員idがFavoritesテーブル内に存在(exist?)するか
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  # whereは完全一致を求めるメソッド likeであいまい検索
  def self.search(keyword)
    where(["title like?", "%#{keyword}%"])
  end
end
