# frozen_string_literal: true

class Public::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # callback for google
  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    # customer.rbで記述したメソッド(from_omniauth)をここで使っています
    # "request.env["omniauth.auth"]"この中にgoogleアカウントから取得したメールアドレスや、名前と言ったデータが含まれています
    @customer = Customer.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @customer, event: :authentication
    set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  end

  def failure
    redirect_to request.referer
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
