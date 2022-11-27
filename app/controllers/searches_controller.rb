class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :search

  def index
    @range = params[:range]
  end

  def search
    @q = User.ransack(params[:q])
  end

  def show
    @results = @q.result(distinct: true)
  end
end
