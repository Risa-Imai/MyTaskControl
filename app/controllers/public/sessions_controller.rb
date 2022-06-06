# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :customer_state, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    customer_path(current_customer)
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  protected

  # 退会済みか確認するメソッド
  def customer_state
    ## 処理1 入力されたemailからアカウントを1件取得
    @customer = Customer.find_by(email: params[:customer][:email])
    ## アカウントを取得できなかった場合、このメソッドを終了
    return if !@customer
    ## 処理2 取得したアカウントのパスワードと入力されたパスワードが一致しているかを判断
    if @customer.valid_password?(params[:customer][:password]) && (@customer.is_delete == true)
      redirect_to new_customer_registration_path
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
