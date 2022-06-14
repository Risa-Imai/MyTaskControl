class Public::TaskCommentsController < ApplicationController
  before_action :authenticate_customer!

  def create
    # 非同期する時に必要なデータ
    @task = Task.find(params[:task_id])
    @task_comment = TaskComment.new
    # コメント投稿
    task = Task.find(params[:task_id])
    comment = TaskComment.new(task_comment_params)
    comment.customer_id = current_customer.id
    # comment = current_customer.task_comments.new(task_comment_params)
    comment.task_id = task.id
    if comment.save
      flash.now[:notice] = "コメントしました"
      # redirect_to request.referer, notice: "コメントしました"
    else
      redirect_to request.referer, alert: "2~140文字で入力してください"
    end
  end

  def destroy
    # 非同期する時に必要なデータ
    @task = Task.find(params[:task_id])
    @task_comment = TaskComment.new
    # コメント削除
    task_comment = TaskComment.find_by(id: params[:id], task_id: params[:task_id])
    task_comment.destroy
      flash.now[:notice] = "コメントを削除しました"
    # redirect_to request.referer
  end

  private

  def task_comment_params
    params.require(:task_comment).permit(:comment)
  end

end
