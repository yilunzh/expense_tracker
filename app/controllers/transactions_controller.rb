class TransactionsController < ApplicationController
	before_action :authenticate_user!
	# load_and_authorize_resource param_method: :transaction_params

	def index
		@transactions = Transaction.where( "user_id = ?", current_user[:id] )
		@user = current_user
	end

	def new
		@transaction = Transaction.new
	end

	def edit
		@transaction = Transaction.find(params[:id])
	end

	def create
		@user = current_user
		@transaction = @user.transactions.new(transaction_params)
		@transaction.user_id = current_user.id
		if @transaction.save
			redirect_to transactions_path
		else
			render 'new'
		end
	end

	def update
		@transaction = Transaction.find(params[:id])

		if @transaction.update_attributes(transaction_params)
			redirect_to transactions_path
		else
			render 'edit'
		end
	end

	def destroy
		@transaction = Transaction.find(params[:id])
		@transaction.destroy
		flash[:success] = "transaction deleted"
		redirect_to transactions_path
	end

	def summary
		@users = ["Bibi", "Pipi"]
	end

	private

		def transaction_params
			params.require(:transaction).permit(:purchase_date, :category, :description, :amount)
		end
end
