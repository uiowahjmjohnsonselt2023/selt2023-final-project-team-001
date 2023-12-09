class MessagesController < ApplicationController
  before_action :require_login

  def new
    @message = Message.new

    @profile_id = params[:profile_id]
    @profile = Profile.find @profile_id
    @receiver_id = @profile.user_id
    @name = @profile.user.full_name

    if Current.user.id == @receiver_id.to_i
      flash[:alert] = "You cannot send a message to yourself."
      p_id = Profile.find_by(user_id: Current.user.id).id
      if p_id.nil?
        redirect_to root_path
      else
        redirect_to profile_path(p_id)
      end
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
    sender_name = Current.user.full_name
    receiver_name = User.find_by(id: params[:receiver_id]).full_name
    message = Message.new(receiver_id: params[:receiver_id], sender_id: Current.user.id, subject: params[:message][:subject], message: params[:message][:message], sender_name: sender_name, receiver_name: receiver_name)
    if message.save
      flash[:success] = "Reply successfully sent!"
      redirect_to view_messages_path
    else
      render "reply", status: :unprocessable_entity
    end
  end

  def create
    sender_name = Current.user.full_name
    receiver_name = User.find_by(id: params[:receiver_id]).full_name
    message = Message.new(receiver_id: params[:receiver_id], sender_id: Current.user.id, subject: params[:message][:subject], message: params[:message][:message], sender_name: sender_name, receiver_name: receiver_name)
    if message.save
      flash[:success] = "Message successfully sent!"
      redirect_to profile_path(params[:profile_id])
    else
      render "new", status: :unprocessable_entity
    end
  end

  def inbox
    @messages = Message.where(receiver_id: Current.user.id)
  end

  def sent
    @messages = Message.where(sender_id: Current.user.id)
  end

  def show
    @message = Message.find_by(id: params[:message_id])
    @reply_enabled = true
    if Current.user.id == @message.sender_id
      @message.update(hasRead: true)
      @reply_enabled = false
    end
  end

  def delete
    if params[:confirmation] == "yes"
      Message.find_by(id: params[:message_id]).destroy
      flash[:success] = "Message deleted."
    end
    redirect_to view_messages_path
  end
end
