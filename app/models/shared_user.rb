class SharedUser < ActiveRecord::Base
	belongs_to :user

	belongs_to :shared_user, :class_name => "User", :foreign_key => "shared_user_id"

	validates_uniqueness_of :shared_email, scope: :user_id

	def self.get_shared_user_list(user_id)
		user_ids = [user_id]
		user = User.find(user_id)	
		user.shared_users.each do |shared_user|
			user_ids.append(shared_user[:shared_user_id])
		end

		return user_ids
	end
end
