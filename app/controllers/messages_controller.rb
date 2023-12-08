class MessagesController < ApplicationController
  before_action :require_login

  def new
    @message = Message.new

    @profile_id = params[:profile_id]
    @profile = Profile.find @profile_id
    @receiver_id = @profile.user_id
    @name = (@profile.first_name || "") + " " + (@profile.last_name || "")

    if Current.user.id == @receiver_id.to_i
      flash[:alert] = "You cannot send a message to yourself."
      redirect_to profile_path(Profile.find_by(user_id: Current.user.id).id)
    end
  end

  def reply
    @message = Message.new

    @message_replying_to = params[:message]
    @subject_replying_to = params[:subject]
    @receiver_name = params[:sender_name]
    @receiver_id = params[:sender_id]
  end

  def create_reply
    @sender_name = User.find_by(id: Current.user.id.to_s).full_name
    message = Message.new(receiver_id: params[:receiver_id], sender_id: Current.user.id, subject: params[:message][:subject], message: params[:message][:message], sender_name: @sender_name)
    if message.save
      flash[:success] = "Reply successfully sent!"
      redirect_to view_messages_path
    else
      render "reply", status: :unprocessable_entity
    end
  end

  def create
    @sender_name = User.find_by(id: Current.user.id.to_s).full_name
    message = Message.new(receiver_id: params[:receiver_id], sender_id: Current.user.id, subject: params[:message][:subject], message: params[:message][:message], sender_name: @sender_name)
    if message.save
      flash[:success] = "Message successfully sent!"
      redirect_to profile_path(params[:profile_id])
    else
      render "new", status: :unprocessable_entity
    end
  end

  def index
    # display all messages
    @messages = Message.where(receiver_id: Current.user.id)
  end

  def show
    @message = Message.find_by(id: params[:message_id])
  end

  def delete
    if params[:confirmation] == "yes"
      Message.find_by(id: params[:message_id]).destroy
      flash[:success] = "Message deleted."
    end
    redirect_to view_messages_path
  end
end
