class Guest::SessionsController < Devise::SessionsController
  # ゲストログイン機能追加
  def guest_sign_in
    # カリキュラムはUserだが ポートフォリオはカスタマー
    customer = Customer.guest
    # ログインする
    sign_in customer
    redirect_to customer_path(customer), notice: "ゲストユーザーでログインしました"
  end
  
end