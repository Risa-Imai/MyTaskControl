class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name, presence: true, length: { minimum: 1, maximum: 10 }
  validates :first_name, presence: true, length: { minimum: 1, maximum: 10 }

  has_many :tasks, dependent: :destroy
  has_many :task_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_one_attached :customer_image

  # 画像サイズを指定できるように
  def get_customer_image(width, height)
    unless customer_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      customer_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    customer_image.variant(resize_to_limit: [width, height]).processed
    # 質問した際に教えていただいた内容
    # customer_image.variant(resize: "#{width}x#{height}").processed
  end

  # 会員のフルネーム
  def full_name
    last_name + " " + first_name
  end

  # ゲストログイン用メソッド
  def self.guest
    # 存在するかしないかを判断し名前とメールアドレスとパスワードの作成
    find_or_create_by!(first_name: "customer", last_name: "guest", email: "guest@example.com") do |customer|
      # 今回必要なログインの情報はメールアドレスとパスワード
      customer.password = SecureRandom.urlsafe_base64
      customer.email = "guest@example.com"
    end
  end

  # 正規ユーザーのみを認める記述
  def active_for_authentication?
    super && (is_delete == false)
  end

  def self.search(keyword)
    # if keyword == "有効"
    #   status = false
    # elsif keyword == "退会"
    #   status = true
    # end

    # whereだと完全一致 likeだとあいまいな検索が出来る
    # ORはどちらか一方にでも検索キーワードが部分一致すれば出力する
    # ANDを用いる時は両方にヒットした場合のみ
    where(["first_name like? OR last_name like?", "%#{keyword}%", "%#{keyword}%"])
    # where(is_delete: status)

  end

  # フォローしたときの処理
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end
  # フォローを外すときの処理
  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end
  # フォローしているか判定
  def following?(customer)
    followings.include?(customer)
  end

end
