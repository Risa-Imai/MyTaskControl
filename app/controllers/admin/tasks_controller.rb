class Admin::TasksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to admin_tasks_path, notice: "#{@task.customer.full_name}さんのタスクを削除しました"
    end
  end
end
