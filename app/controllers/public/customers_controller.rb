class Public::CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
    # 他人の編集画面には飛べない記述
    if @customer == current_customer
      render :edit
    else
      redirect_to customer_path(current_customer)
    end
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

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :customer_image, :introduction)
  end
end
