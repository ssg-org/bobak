class Owner < ActiveRecord::Base
  include PgSearch

  attr_accessible :city, :oid, :name, :address
  validate :name

  has_many :accounts
  has_many :owner_statuses

  # Free text search
  pg_search_scope :search_full_text, 
  								:against => :name,
  								:using => {
	                    tsearch: {
	                      tsvector_column: 'full_text'
  	                  }
  									}

  def self.search(query, offset = 0, limit = 10)
    off = offset.blank? ? 0 : offset.to_i
    lim = limit.blank? ? 10 : limit.to_i

    return self.search_full_text(query).offset(off).limit(lim)
  end
end
