class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  
  def index
    @users = User.all.order(id: :DESC)
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(name: params[:name], email: params[:email], image_name: "default.jpg", password: params[:password])
    if @user.save
      flash[:notice] = "ユーザーを登録しました"
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
      
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    
    if @user.save
      flash[:notice] = "ユーザーを編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def destroy
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
    @posts = Post.where(user_id: @user.id)
    
    #Like情報の削除
    @likes.each do |like|
      like.destroy
    end
    
    #投稿データの削除
    @posts.each do |post|
      post.destroy
    end
    
    #ユーザー情報の削除
    @user.destroy
    
    #セッションを終了
    session[:user_id] = nil
    
    flash[:notice] = "ユーザーを削除しました"
    #ホーム画面にリダイレクト
    redirect_to("/")
  end
  
  def login_form
    @user = User.new
  end
  
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
  
  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end
  
  #ログインユーザーと、編集or削除しようとしているユーザーが違う場合は、アクセス禁止
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "アクセスできません"
      redirect_to("/posts/index")
    end
  end
end
