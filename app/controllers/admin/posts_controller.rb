class Admin::PostsController < Admin::BaseController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    3.times do
      @post.images.build
    end
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:success] = "Post succesfully created"
      redirect_to admin_posts_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    (3 - @post.images.count).times do
     @post.images.build
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    redirect_to admin_posts_path

  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end


end
