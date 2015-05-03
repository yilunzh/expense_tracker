class SharedUsersController < ApplicationController
	before_action :authenticate_user!

	def index
		@shared_users = current_user.shared_users
	end

	def new
		@shared_user = SharedUser.new
	end

	def create
		@shared_user = current_user.shared_users.new(shared_user_params)
		user = User.find_by_email(@shared_user.shared_email)	
		@shared_user.shared_user_id = user.id if user
		@shared_user.user_id = current_user.id
		if @shared_user.save
			@shared_user_2 = SharedUser.create(user_id: user.id, shared_email: current_user[:email], shared_user_id: current_user[:id])
			redirect_to shared_users_path
		else
			render 'new'
		end
	end
	
	def destroy
		@shared_user1 = SharedUser.find(params[:id])
		@shared_user2 = SharedUser.where("user_id = ? and shared_user_id = ?", @shared_user1.shared_user_id, @shared_user1.user_id)[0]
		name = @shared_user1[:shared_email]
		if @shared_user1 and @shared_user2
			@shared_user1.destroy
			@shared_user2.destroy
			flash[:success] = "#{name} has been removed from company. You also no longer have access to #{name}'s transactions"
			redirect_to shared_users_path
		else
			flash[:alert] = "something went wrong. Sharing permission between 2 accounts not in sync"
			render "index"
		end
	end

	private

		def shared_user_params
			params.require(:shared_user).permit(:shared_email, :message)
		end
end
