class SharedUsersController < ApplicationController
	def index
		@shared_users = current_user.shared_users
	end

	def new
		@shared_user = SharedUser.new
	end

	def edit
		@shared_user = SharedUser.find(params[:id])
	end

	def create
		@shared_user = current_user.shared_users.new(shared_user_params)
		user = User.find_by_email(@shared_user.shared_email)	
		@shared_user.shared_user_id = user.id if user
		@shared_user.user_id = current_user.id
		if @shared_user.save
			redirect_to shared_users_path
		else
			render 'new'
		end
	end

	def update
		@shared_user = SharedUser.find(params[:id])
		if @shared_user.update_attributes(shared_user_params)
			redirect_to shared_users_path
		else
			render 'edit'
		end
	end

	def destroy
		@shared_user = SharedUser.find(params[:id])
		name = @shared_user[:shared_email]
		@shared_user.destroy
		flash[:success] = "#{name} has been removed from company"
		redirect_to shared_users_path
	end

	private

		def shared_user_params
			params.require(:shared_user).permit(:shared_email, :message)
		end
end
