class Owner < ActiveRecord::Base
  include PgSearch

  attr_accessible :city, :oid, :name, :address
  validate :name

  has_many :accounts

  # Free text search
  pg_search_scope :search_full_text, 
  								:against => [:oid, :name],
  								:using => {
	                    tsearch: {
	                      tsvector_column: 'full_text'
  	                  }
  									}

  # Fuzzy search
  pg_search_scope :search_trigram,
                  :against => :name,
                  :using => :trigram

  def self.search(query, offset = 0, limit = 10)
    off = offset.blank? ? 0 : offset.to_i
    lim = limit.blank? ? 10 : limit.to_i

    return (self.search_full_text(query) + self.search_trigram(query)).slice(off, lim)
  end
end
