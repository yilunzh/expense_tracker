class TransactionsController < ApplicationController
	before_action :authenticate_user!
	helper_method :agreed_contribution

	def index
		user_ids = SharedUser.get_shared_user_list(current_user[:id])
		@transactions = []

		user_ids.each do |user_id|
			@transactions.append(Transaction.where("user_id = ?", user_id))
		end

		@transactions.flatten!.sort_by!{|a| a[:purchase_date]}

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

		@users = []
		
		@user_ids = SharedUser.get_shared_user_list(current_user[:id])
		
		dt = DateTime.now
		@current_year = dt.year
		@most_recent_month = dt.month - 1
		@transactions = Transaction.by_month(@current_year, @most_recent_month)

		@total_spend = 0
		@transactions.each do |transaction|
			@total_spend += transaction.amount
		end

		@total_budget = 0
		@user_ids.each do |id|
			@total_budget += ContribConfig.find_by_user_id(id).budgeted_contrib
		end

		@display = {}
		@user_ids.each do |id|
			agreed_contribution = agreed_contribution(id, @total_spend, @total_budget)
			paid = @transactions.total_spend_by_user(id)

			@display[id] = { name: User.find(id).name,
												agreed_contribution: agreed_contribution,
												paid: paid,
												owe: paid - agreed_contribution,
												balance: 0 }
		end
	end

	private

		def transaction_params
			params.require(:transaction).permit(:purchase_date, :category, :description, :amount)
		end


		def agreed_contribution(user_id, total_spend, total_budget)
			contrib_config = ContribConfig.find_by_user_id(user_id)
			agreed_contribution = contrib_config.budgeted_contrib + (total_spend - total_budget) * contrib_config.over_spend/100

			return agreed_contribution
		end
end
