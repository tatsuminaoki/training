class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:notice] = "ユーザー名かパスワードに誤りがあります"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find_by!(mail: session_params[:mail])
  rescue
    flash.now[:danger] = t('.flash.invalid_mail')
    render action: 'new'
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
