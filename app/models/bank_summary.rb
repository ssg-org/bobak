class BankSummary < ActiveRecord::Base
	attr_accessible :bank_id, :date, :blocked_accounts, :blocked_owners

	belongs_to :bank

	def self.get_top_banks_by_accounts(limit = 10, date = nil)
  	return BankSummary.includes(:bank).order('blocked_accounts DESC').limit(limit).where(:date => date)
  end

  def self.get_top_banks_by_owners(limit = 10, date = nil)
  	return BankSummary.includes(:bank).order('blocked_owners DESC').limit(limit).where(:date => date)
  end
end