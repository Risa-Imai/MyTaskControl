class Admin::TasksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tasks = Task.latest.page(params[:page])
    @tag_list = Tag.find(TaskTag.group(:tag_id).order("count(task_id) desc").limit(25).pluck(:tag_id))
    # @tag_list = Tag.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to admin_tasks_path, alert: "#{@task.customer.full_name}さんのタスクを削除しました"
    end
  end

  def search
    @tasks = Task.search(params[:keyword]).latest.page(params[:page])
    # renderしているのでpageメソッドを渡している
    @keyword = params[:keyword]
    @tag_list = Tag.find(TaskTag.group(:tag_id).order("count(task_id) desc").limit(25).pluck(:tag_id))
    # @tag_list = Tag.all
    render :index
  end

  def tag_search
    @tag = Tag.find(params[:tag_id])
    @tasks = @tag.tasks.latest.page(params[:page])
    @tag_list = Tag.find(TaskTag.group(:tag_id).order("count(task_id) desc").limit(25).pluck(:tag_id))
    # @tag_list = Tag.all
    # @tasks = Task.includes(:tags).where(tags: {id: @tag}).page(params[:page])
    render :index
  end
end
