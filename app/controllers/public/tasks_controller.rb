class Public::TasksController < ApplicationController

  def create
    @task = Task.new(task_params)
    @task.customer_id = current_customer.id
    @task.save
    redirect_to request.referer, notice: "タスクを投稿しました！頑張りましょう！"
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
      redirect_to tasks_path, notice: "タスクを削除しました"
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :progress_status)
  end
end
