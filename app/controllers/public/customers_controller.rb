class Public::CustomersController < ApplicationController
  # 他ユーザーの編集・退会は行えない
  before_action :ensure_guest_to_customer, only: [:edit, :update]
  before_action :collect_guest_to_customer, only: [:unsubscribe, :withdraw]

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
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
    #ログアウトさせる
    reset_session
    redirect_to root_path
  end

  private

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

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :customer_image, :introduction)
  end
end
