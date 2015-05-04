class ContribConfigsController < ApplicationController
	def index
		@configs = ContribConfig.all
	end

	def new
		@config = ContribConfig.new
	end

	def edit
	end

	def create
		@config = ContribConfig.new(contrib_config_params)
		@config.user_id = current_user[:id]
		if @config.save
			redirect_to contrib_configs_path
		else
			render 'new'
		end
	end

	def edit
	end

	def destroy
		@config = ContribConfig.find(params[:id])
		@config.destroy
		flash[:success] = "the configuration has been successfully deleted"
		redirect_to contrib_configs_path
	end

	private
		def contrib_config_params
			params.require(:contrib_config).permit(:budgeted_contrib, :over_spend)
		end
end
