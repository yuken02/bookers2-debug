class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    @books_chart = Book.all
    # @books = Book.includes(:favorited_users).sort.reverse
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
    # @books = Book.joins(:favorites).where(favorites: {created_at: from..to}).group(:book_id).order("count(book_id) desc")
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    is_matching_login_user
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end

  def is_matching_login_user
    login_user_id = current_user.id
    if (@book.user_id != login_user_id)
      redirect_to books_path
    end
  end
end
