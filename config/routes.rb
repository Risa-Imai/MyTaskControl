Rails.application.routes.draw do
  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
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

  ## 会員用
  root to: "public/homes#top"
  get "/about" => "public/homes#about"

  scope module: :public do
  get "customer_search" => "customers#search"
    resources :customers, only: [:index, :show, :edit, :update] do
      # 退会確認画面
      get "unsubscribe" => "customers#unsubscribe"
      # 退会処理 is_deleteをtrueに変更
      patch "withdraw" => "customers#withdraw"
      # 会員がいいねした一覧を表示
      get "favorites" => "customers#favorites"
      # フォロー登録・解除
      resource :relationships, only: [:create, :destroy]
      # フォロー一覧ページ
      get "followings" => "relationships#followings", as: "followings"
      # フォロワー一覧ページ
      get "followers" => "relationships#followers", as: "followers"

    end

  get "task_search" => "tasks#search"
  get "tag_search" => "tasks#tag_search"
    resources :tasks do
      #タスクにコメント機能
      resources :task_comments, only: [:create, :destroy]
      #タスクにいいね機能
      resource :favorites, only: [:create, :destroy]
    end
  end

  ## 管理者用
  namespace :admin do
  get "customer_search" => "customers#search"
    resources :customers, only: [:index, :show, :edit, :update]

    resources :tasks, only: [:index, :show, :destroy] do
      resources :task_comments, only: [:destroy]
    end
  end
end
