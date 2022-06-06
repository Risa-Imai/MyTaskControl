class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name, presence: true
  validates :first_name, presence: true

  has_many :tasks, dependent: :destroy
  has_many :task_comments, dependent: :destroy

  has_one_attached :customer_image

  # 画像サイズを指定できるように
  def get_customer_image(width, height)
    unless customer_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      customer_image.attach(io: File.open(file_path), filename: "default-imae.jpg", content_type: "image/jpeg")
    end
    customer_image.variant(resize_to_limit: [width, height]).processed
  end

  # 会員のフルネーム
  def full_name
    last_name + " " + first_name
  end

  # ゲストログイン用メソッド
  def self.guest
    #存在するかしないかを判断し名前とメールアドレスとパスワードの作成
    find_or_create_by!(first_name: "customer", last_name: "guest", email: "guest@example.com") do |customer|
      # 今回必要なログインの情報はメールアドレスとパスワード
      customer.password = SecureRandom.urlsafe_base64
      customer.email = "guest@example.com"
    end
  end
end
