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

  # タグ機能について
  def save_tasks(tags)
    # createアクションで保存した@taskに紐付くタグが存在する場合
    # 「タグの名前を配列として」全て取得する
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得した@taskに存在するタグから、送信されてきたタグを除いたタグをold_tags
    old_tags = current_tags - tags
    # 送信されてきたタグから、現在存在するタグを除いたタグをnew_tags
    new_tags = tags - current_tags
    # 古いタグを削除処理
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end
    # 新しいタグをデータベースに保存する処理
    new_tags.each do |new_name|
      task_tag = Tag.find_or_create_by(name: new_name)
      if task_tag.valid?
        self.tags << task_tag
      else

      end
    end
  end

  # 並べ替え
  scope :latest, -> { order(created_at: :desc) }
end
