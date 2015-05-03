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
	end

	def edit
	end

	def destroy
	end
end
