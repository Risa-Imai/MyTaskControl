Rails.application.routes.draw do
  # 顧客用
  # URL /customers/dign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  root to: "public/homes#top"
  get "/about" => "public/homes#about"

  scope module: :public do
    resources :customers do
      #退会確認画面
      get "unsubscribe" => "customers#unsubscribe"
      #退会処理 is_deleteをtrueに変更
      patch "withdraw" => "customers#withdraw"
    end

    resources :tasks
  end

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
  end
end
