Rails.application.routes.draw do
  # 顧客用
  # URL /customers/dign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  # ゲストユーザー機能
  devise_scope :customer do
    post "customers/guest_sign_in", to: "guest/sessions#guest_sign_in"
  end

  root to: "public/homes#top"
  get "/about" => "public/homes#about"

  scope module: :public do
    resources :customers, only: [:index, :show, :edit, :update] do
      #退会確認画面
      get "unsubscribe" => "customers#unsubscribe"
      #退会処理 is_deleteをtrueに変更
      patch "withdraw" => "customers#withdraw"
      #会員がいいねした一覧を表示
      get "favorites" => "customers#favorites"
    end

    resources :tasks do
      resource :favorites, only: [:create, :destroy]
    end
  end

  ## 管理者用
  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :tasks, only: [:index, :show, :destroy]
  end
end
