class Firm < ActiveRecord::Base
  include PgSearch

  attr_accessible :city, :jib, :name
  validate :jib

  has_many :accounts

  # Free text search
  pg_search_scope :search_full_text, 
  								:against => [:jib, :name],
  								:using => {
#  									trigram: {}
	                    tsearch: {
	                      tsvector_column: 'full_text'
  	                  }
  									}

  # FT Search by string query 
  def self.search_query(search_terms, limit = query_limit)
  	words = sanitize(search_terms.scan(/\w+/) * "|")

  	Firm.from("firms, to_tsquery('pg_catalog.english', #{words}) as q").where('full_text @@ q').order("ts_rank_cd(full_text, q) DESC").limit(limit)
  end

  # Default number of results
  def self.query_limit
  	25
  end
end
