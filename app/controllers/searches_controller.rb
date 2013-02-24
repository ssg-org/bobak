class SearchesController < ApplicationController
	def show
		@owners = Owner.search(params[:q], params[:o], params[:l])
	end
end