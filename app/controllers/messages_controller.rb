class MessagesController < ApplicationController
  before_action :require_login

  def new
    @profile_id = params[:profile_id]
    @profile = Profile.find @profile_id
    @receiver_id = @profile.user_id
    @name = @profile.first_name + " " + @profile.last_name

    if Current.user.id == @receiver_id.to_i
      flash[:alert] = "You cannot send a message to yourself."
      redirect_to profile_path(Profile.find_by(user_id: Current.user.id).id)
    end
  end

  def create
    Message.create(receiver_id: @receiver_id, sender_id: Current.user.id, subject: params[:subject], message: params[:message])
    flash[:success] = "Message successfully sent!"
    redirect_to profile_path(params[:profile_id])
  end

  def index
    # display all messages
  end
end
