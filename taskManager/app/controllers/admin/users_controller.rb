module Admin
  class UsersController < ApplicationController
    before_action :set_admin_user, only: %i[show edit update destroy]

    def index
      @admin_users = Admin::User
        .eager_load(:tasks)
        .all
    end

    def show
    end

    def new
      @admin_user = Admin::User.new
    end

    def edit
    end

    def create
      @admin_user = Admin::User.new(admin_user_params)

      respond_to do |format|
        if @admin_user.save
          format.html { redirect_to @admin_user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @admin_user }
        else
          format.html { render :new }
          format.json { render json: @admin_user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @admin_user.update(admin_user_params)
          format.html { redirect_to @admin_user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @admin_user }
        else
          format.html { render :edit }
          format.json { render json: @admin_user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @admin_user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def set_admin_user
      @admin_user = Admin::User.find(params[:id])
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
  end
end
