class Bank < ActiveRecord::Base
  attr_accessible :city, :name

  has_many :accounts
  has_many :bank_summaries
end
