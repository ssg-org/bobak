class Owner < ActiveRecord::Base
  include PgSearch

  attr_accessible :city, :oid, :name, :address
  validate :name

  has_many :accounts
  has_many :owner_summaries

  # Free text search
  pg_search_scope :search_full_text, 
  								:against => :name,
  								:using => {
	                    tsearch: {
	                      tsvector_column: 'full_text'
  	                  }
  									}

  def self.search(query, offset = 0, limit = 10, month = nil, year = nil)

    results = self
      .includes(:owner_summaries)
      .where(:owner_summaries => {:year => year, :month => month})
      .search_full_text(query)
      .reorder('owner_summaries.blocked_accounts DESC')
      .offset(offset)
      .limit(limit)

    return results
  end
end
