class Admin::CustomersController < ApplicationController
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
      redirect_to admin_customer_path(@customer.id), notice: "情報を更新しました"
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :customer_image, :email, :is_delete)
  end
end
