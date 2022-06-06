class Public::CustomersController < ApplicationController
  # ゲストユーザーは編集画面は遷移できない
  before_action :ensure_guest_customer, only: [:edit]

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
      redirect_to customer_path(current_customer), notice: "変更内容を保存しました"
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
  end

  private

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.email == "guest@example.com"
      redirect_to customer_path(current_customer), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません"
    end
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :customer_image, :introduction)
  end
end
