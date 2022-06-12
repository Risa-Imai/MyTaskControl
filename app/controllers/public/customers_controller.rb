class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  # 他ユーザーの編集・退会は行えない
  before_action :ensure_guest_to_customer, only: [:edit, :update]
  before_action :collect_guest_to_customer, only: [:unsubscribe, :withdraw]

  def index
    @customers = Customer.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
    # Task.new(task_params)を持ってくる方法が分からない
    @task = Task.new
    # 詳細を表示しているユーザーの投稿全てを取得
    @tasks = @customer.tasks.page(params[:page])
    @customer_tasks = @customer.tasks
    # @tag_list = Tag.all
    # @tag_list = @customer.tasks.pluck
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer_image = @customer.customer_image
    if @customer.update(customer_params)
      redirect_to customer_path(current_customer), notice: "情報を更新しました"
    else
      render :edit
    end
  end

  def unsubscribe
    @customer = Customer.find(params[:customer_id])
  end

  # 退会処理
  def withdraw
    @customer = Customer.find(params[:customer_id])
    @customer.update(is_delete: true)
    # ログアウトさせる
    reset_session
    redirect_to root_path
  end

  def favorites
    @customer = Customer.find(params[:customer_id])
    # pluckは指定したカラムを配列で取得する
    @favorites = @customer.favorites.page(params[:page])
    # whereはカラムの中が一致してるものを探してる
    # @favorites = Favorite.where(customer_id: @customer.id).page(params[:page])
    # ページネーションの変数は@favorites
    @favorite_tasks = Task.find(@favorites.pluck(:task_id))
    # favorites = Favorite.where(customer_id: @customer.id).pluck(:task_id)
    # @favorite_tasks = Task.find(favorites)
  end

  def search
    @customers = Customer.search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    render :index
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :customer_image, :introduction)
  end

  def ensure_guest_to_customer
    @customer = Customer.find(params[:id])
    if @customer.email == "guest@example.com"
      redirect_to customer_path(current_customer), notice: "ゲストユーザーはプロフィール編集が出来ません"
    end
    if @customer != current_customer
      redirect_to customer_path(current_customer), notice: "他ユーザーのプロフィール編集は出来ません"
    end
  end

  def collect_guest_to_customer
    @customer = Customer.find(params[:customer_id])
    if @customer.email == "guest@example.com"
      redirect_to customer_path(current_customer), notice: "ゲストユーザーは退会出来ません"
    end
    if @customer != current_customer
      redirect_to customer_path(current_customer), notice: "他ユーザーの退会は出来ません"
    end
  end

end
