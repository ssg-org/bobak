class SearchesController < ApplicationController
	MAX_LIMIT = 20

	def show
		limit = params[:l].to_i > 0 ? [MAX_LIMIT, params[:l].to_i] : MAX_LIMIT 
		offset = params[:o].to_i

		@owners = Owner.search(params[:q], offset, limit)
	end
end