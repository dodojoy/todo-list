class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url }
  before_action :redirect_user_to_tasks, only: [ :new ]

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      @login_error = "Email or password is invalid"
      respond_to do |format|
        format.html { redirect_to new_session_path }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("login_form_errors", 
            partial: "sessions/error_message", 
            locals: { error: @login_error }
          )
        }
      end
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  # def destroy
  #   session[:user_id] = nil
  #   # redirect_to(new_sessions_path, notice: "Logged out!")
  # end
end
