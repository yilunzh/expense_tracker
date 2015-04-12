class Transaction < ActiveRecord::Base

	def self.total_spend
		total = 0

		Transaction.all.each do |row|
			total += row.amount
		end

		return total
	end

	def self.total_spend_by_user(user)
		total = 0

		Transaction.where(paid_by: user).each do |row|
			total += row.amount
		end

		return total
	end

end
