module Helpers
  def login_as(user)
    session[:user_id] = user.id
  end
end
