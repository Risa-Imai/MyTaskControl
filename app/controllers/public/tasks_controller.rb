class Public::TasksController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def create
    @task = Task.new(task_params)
    @task.customer_id = current_customer.id
    @task.save
    redirect_to customer_path(current_customer), notice: "タスクを投稿しました！頑張りましょう！"
  end

  def index
    @task = Task.new
    @customer = current_customer
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
    # ステータス毎に文字色を変更する為のクラスをあてがう
    @status = @task.progress_status
    # 日本語化の表記
    @status_i18n = @task.progress_status_i18n
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "進捗を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to customer_path(current_customer), notice: "タスクを削除しました"
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :progress_status)
  end

  def ensure_correct_customer
    @task = Task.find(params[:id])
    if @task.customer != current_customer
      redirect_to customer_path(current_customer), notice: "他ユーザーのタスクは編集できません"
    end
  end

end
