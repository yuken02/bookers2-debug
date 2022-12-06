class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today = Date.today
    # @today = Date.current.strftime('%Y,%m,%d')
    # @today = Time.now
    # @today_book = Book.where(created_at: Time.local(@today.to_i)..Time.local(@today.to_i))
    @today_book = @books.where('created_at > ?', Date.today)
    @yesterday_book = @books.where('created_at > ?', Date.today-1)

  end

  def index
    @users = User.all
    @book = Book.new
    # @q = User.ransack(params[:q])
    # @results = @q.result(distinct: true)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_correct_user
  	if current_user.id != params[:id].to_i
  		flash[:notice] = "権限がありません"
  		redirect_to user_path(current_user)
  	end
  end
end
