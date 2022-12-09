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

    ### DM機能
    @current_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id then
            @room = true
            @room_id = cu.room_id
          end
        end
      end
      unless @room
        @room = Room.new
        @entry = Entry.new
      end
    end

    # rooms = current_user.entry.pluck(:room_id)
    # user_room = Entry.find_by(user_id: @user.id, room_id: rooms)
    # if user_room.nil?
    #   @room = Room.create()
    #   Entry.create(user_id: current.id, room_id: @room.id)
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
