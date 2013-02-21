class SearchesController < ApplicationController
	def show
		@firms = Firm.search_full_text(params[:q])
	end
end