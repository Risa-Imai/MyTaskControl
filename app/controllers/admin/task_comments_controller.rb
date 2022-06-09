class Admin::TaskCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    task_comment = TaskComment.find_by(id: params[:id], task_id: params[:task_id])
    task_comment.destroy
    redirect_to request.referer
  end
end
