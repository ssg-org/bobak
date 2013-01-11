class Firm < ActiveRecord::Base
  attr_accessible :city, :jib, :name

  has_many :accounts
end
