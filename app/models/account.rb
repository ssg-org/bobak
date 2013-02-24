class Account < ActiveRecord::Base
  attr_accessible :bank_id, :owner_id, :number, :name

  belongs_to :bank
  belongs_to :owner
  has_many :account_statuses
end
