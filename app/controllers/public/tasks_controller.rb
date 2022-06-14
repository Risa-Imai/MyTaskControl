class Public::TasksController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def create
    @task = Task.new(task_params)
    @task.customer_id = current_customer.id
    # 送られたタグ情報をsplit(",")でカンマ区切り(配列化)
    # deleteでタグの前後にある半角スペースと全角スペースを削除
    tag_list = params[:task][:tag_name].delete(" ").delete("　").split(",").uniq #.split(nil)
    if @task.save
      # save_tasksはモデルで記述
      @task.save_tasks(tag_list)
      redirect_to customer_path(current_customer), notice: "タスクを投稿しました！頑張りましょう！"
    else
      redirect_to request.referer, notice: "タスクを入力してください"
      # renderだとURLがtasksになってしまい不格好の為コメントアウト(動作は問題なし)
      # @customer = current_customer
      # @tasks = current_customer.tasks
      # render "public/customers/show", notice: "タスクとステータスを入力してください"
    end
  end

  def index
    @customer = current_customer
    @tasks = Task.latest.page(params[:page])
    # viewで使用する
    @tag_list = Tag.all
  end

  def show
    @task = Task.find(params[:id])
    # コメント非同期通信した時に必要
    @task_comment = TaskComment.new
    @task_comments = @task.task_comments.order(created_at: "DESC")
    # ステータス毎に文字色を変更する為のクラスをあてがう
    @status = @task.progress_status
    # 日本語化の表記
    @status_i18n = @task.progress_status_i18n
  end

  def edit
    @task = Task.find(params[:id])
    @tag_list = @task.tags.pluck(:name).join(",")
  end

  def update
    # コンソールでparamsの中身が見られるようになる
    p params
    @task = Task.find(params[:id])
    tag_list = params[:task][:tag_name].delete(" ").delete("　").split(",").uniq
    if @task.update(task_params)
      @task.save_tasks(tag_list)
      redirect_to task_path(@task), notice: "タスクを更新しました"
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

  def search
    @tasks = Task.search(params[:keyword])
    # renderしているのでpageメソッドを渡している
    @tasks = Task.latest.page(params[:page])
    @keyword = params[:keyword]
    @tag_list = Tag.all
    render :index
  end

  def tag_search
    @tag = Tag.find(params[:tag_id])
    @tasks = @tag.tasks.latest.page(params[:page])
    @tag_list = Tag.all
    # @tasks = Task.includes(:tags).where(tags: {id: @tag}).page(params[:page])
    render :index
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
