class HomeController < ApplicationController

  def index
    @posts = Post.where("").page(params[:page]).per(5)
  end

  def news

  end

  def page

  end

  def post

  end

  def archive

  end

  def gallery

  end

end
