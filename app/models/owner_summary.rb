class OwnerSummary < ActiveRecord::Base
	attr_accessible :owner_id, :date, :blocked_accounts

	belongs_to :owner

	def self.top_owners_by_accounts(limit, date)
  	return OwnerSummary.includes(:owner).order('blocked_accounts DESC').limit(limit).where(:date => date)
	end
end