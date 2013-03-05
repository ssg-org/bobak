class OwnerSummary < ActiveRecord::Base
	attr_accessible :owner_id, :date, :year, :month, :month, :blocked_accounts

	belongs_to :owner

	def self.top_owners_by_accounts(limit, month)
  	return OwnerSummary.includes(:owner).order('blocked_accounts DESC').limit(limit).where(:month => month)
	end
end