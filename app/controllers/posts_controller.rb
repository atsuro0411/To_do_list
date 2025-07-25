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
    Post.create(post_params)

    redirect_to today_posts_path
  end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to today_posts_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to today_posts_path
  end

  def mark
    post = Post.find(params[:id])
    post.update(is_completed: !post.is_completed)
    redirect_back fallback_location: posts_path
  end

  def post_params
    params.require(:post).permit(:content, :due_date, :id)
  end
end
