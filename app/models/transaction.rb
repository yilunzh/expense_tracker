class Transaction < ActiveRecord::Base

	validates_presence_of :purchase_date, :category, :description, :amount, :user_id
	belongs_to :user

	def self.total_spend
		total = 0

		Transaction.all.each do |row|
			total += row.amount
		end

		return total
	end

	def self.total_spend_by_user(user_id)
		total = 0

		self.where("user_id = ?", user_id).each do |row|
			total += row.amount
		end

		return total
	end

	def self.by_month(year, month)
		
		dt = DateTime.new(year, month)
		bom = dt.beginning_of_month
		eom = dt.end_of_month
		a = where("purchase_date >= ? and purchase_date <= ?", bom, eom)
		return a
	end

end
