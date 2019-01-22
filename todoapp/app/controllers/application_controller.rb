class ApplicationController < ActionController::Base
  before_action :login_required

  private

  def current_user
    # TODO: あとでログインできるようにするよ
    user = User.find_by(email: 'aaaa@gmail.com')
    if user
      return @current_user = user
    end

    params = {
        email: 'aaaa@gmail.com',
        encrypted_password: 'aaa',
        name: 'aaa',
        group_id: nil,
        role: 1
    }
    user = User.new(params)
    user.save!

    @current_user = user
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
