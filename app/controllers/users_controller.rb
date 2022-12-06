class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    ### 投稿数比較
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    @day_deff = @today_book.count / @yesterday_book.count.to_f
    @week_deff = @this_week_book.count / @last_week_book.count.to_f

    # @today = Date.today
    # @yesterday_book = @books.where('created_at > ?', Date.today-1).count
    # if @yesterday_book == 0
    #   @book_deff = number_to_percentage(@today_book.count)
    # elsif @yesterday_book != 0
    #   @book_deff = (@today_book / @yesterday_book.to_f).to_f
    # end
    # @this_week_book = @books.where(created_at: Date.today-6..Date.today.end_of_day).count
    # @last_week_book = @books.where(created_at: Date.today-13..Date.today-7).count
    # if @last_week_book == 0
    #   @week_book_deff = @this_week_book
    # elsif @last_week_book != 0
    #   @week_book_deff = (@this_week_book / @last_week_book.to_f)
    # end
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
