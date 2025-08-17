class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  before_action :redirect_user_to_tasks
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        start_new_session_for(@user)
        format.html { redirect_to after_authentication_url }
        format.turbo_stream { redirect_to after_authentication_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.replace("user_form", partial: "form", locals: { user: @user })
          ]
        }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email_address, :taken)
    
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.replace("user_form", partial: "form", locals: { user: @user })
        ]
      }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
    end
end
