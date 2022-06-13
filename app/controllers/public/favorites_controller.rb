class Public::FavoritesController < ApplicationController
  def create
    # インスタンスでデータを渡す際のタスクデータ
    # task = Task.find(params[:task_id])
    # インスタンスを作成して必要なカラムを挿入しセーブするまでの流れ
    # favorite = Favorite.new
    # favorite.task_id = task.id
    # favorite.customer_id = current_customer.id
    # favorite.save

    # 上の記述を省略したもの
    Favorite.new(customer_id: current_customer.id, task_id: params[:task_id]).save
    @task = Task.find(params[:task_id])
    # redirect_to request.referer
  end

  def destroy
    task = Task.find(params[:task_id])
    favorite = current_customer.favorites.find_by(task_id: task.id)
    @task = Task.find(params[:task_id])
    favorite.destroy
    # redirect_to request.referer
  end
end