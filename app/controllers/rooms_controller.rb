class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    @current_entry = Entry.create(room_id: @room.id, user_id: current_user.id)
    @user_entry = Entry.create(room_id: @room.id, user_id: params[:entry][:user_id])
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
    @message = Message.new
    @entries = @room.entries
    @user_entry = @entries.where.not(user_id: current_user.id).first
  end
end
