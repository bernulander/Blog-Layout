class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action(:find_post, { only: [:show, :edit, :destroy, :update] })

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = 'Post created successfully'
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'Please fix errors below'
      render :new
    end
  end

  def show
    @comment = Comment.new
    @category = Category.new
    respond_to do |format|
      format.html
      format.json {render json: @post.to_json}
    end
    # @category = Category.find @post.category
  end

  def index
    # if params[:category]
      # ERROR 👇
      # @pOSTS = Post.order(created_at: :desc)#.where("category = '#{params[:category]}'")
    #  else
      @posts = Post.order(created_at: :desc)
    # end
  end

  def edit
    if can? :manage, @post
        redirect_to edit_post_path(@post), notice: 'You\'re authorized'
    else
      redirect_to post_path(@post), notice: '🙅🏿‍♂️ Don\'t be sneaky 👀'
    end
  end

  def update
    if can? :manage, @post
      if @post.update post_params
        redirect_to post_path(@post), notice: 'Post updated!'
      else
        render :edit
      end
    else
      redirect_to post_path(@post), notice: 'Don\'t be sneaky'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post deleted!'
  end


  private

  def post_params
    params.require(:post).permit([:title, :body])
  end

  def find_post
    @post = Post.find params[:id]
  end
end
