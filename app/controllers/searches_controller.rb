class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :search

  def search
    @range = params[:range]
    @method = params[:method]
    @keyword = params[:keyword]

    if @range == "User"
      @users = User.find_out(params[:method],params[:keyword])
    else
      @books = Book.find_out(params[:method],params[:keyword])
    end
  end

end
