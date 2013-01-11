class Account < ActiveRecord::Base
  attr_accessible :bank_id, :firm_id, :number

  belongs_to :bank
end
