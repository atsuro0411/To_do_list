class PostsController < ApplicationController
  def index
    @posts = Post.all.order(:due_date).group_by { |post| post.due_date.to_date }
  end

  def today
    @posts = Post.where(due_date: Date.today.all_day)
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice]="投稿が完了しました"
      redirect_to today_posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)
    if @post.changed?
      if @post.save
        flash[:notice] = "投稿を編集しました"
        redirect_to today_posts_path
      else
          render :edit
      end
    else
        flash[:alert] = "変更がありません"
        redirect_to edit_post_path
    end
  end


  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:alert] = "投稿が削除されました"
    redirect_to today_posts_path
    else
      render edit_post_path
    end
  end

  def mark
    post = Post.find(params[:id])
    post.update(is_completed: !post.is_completed)
    if post.is_completed
      flash[:notice] = "タスクを完了にしました。"
    else
      flash[:notice] = "タスクを未完了に戻しました。"
    end
    redirect_back fallback_location: posts_path
  end

  def post_params
    params.require(:post).permit(:content, :due_date, :id)
  end
end
