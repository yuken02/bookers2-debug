class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    ### 投稿数比較
    @today_books =  @books.created_today
    @yesterday_books = @books.created_yesterday
    @this_week_books = @books.created_this_week
    @last_week_books = @books.created_last_week
    @day_deff = @today_books.count / @yesterday_books.count.to_f
    @week_deff = @this_week_books.count / @last_week_books.count.to_f
  end

  def index
    @users = User.all
    @book = Book.new
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

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    if params[:created_at] == ''
      @search_book = '日付を入力してください'
    else
      created_at = params[:created_at]
      @search_book = @books.where(["created_at LIKE?", "#{created_at}%"]).count
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
