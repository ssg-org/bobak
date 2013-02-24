class AccountStatus < ActiveRecord::Base
  attr_accessible :account_id, :date

  belongs_to :account
end
