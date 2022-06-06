class Public::TasksController < ApplicationController

  def create
    @task = Task.new(task_params)
    @task.customer_id = current_customer.id
    @task.save
    redirect_to request.referer
  end

  def index
    @task = Task.new
    @customer = current_customer
    @tasks = Task.all
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :progress_status)
  end
end
