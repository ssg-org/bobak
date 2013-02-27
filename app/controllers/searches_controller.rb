#encoding: utf-8
class SearchesController < ApplicationController
	MAX_LIMIT = 20

	def show
		@title = "PRETRAGA"
		@titletext = "Želite znati da li firma s kojom poslujete i sama posluje ispravno?\nMi vam omogućujemo brzi pregled ili pretragu firmi."
		@color = "#bd1550"
		@back = true

		limit = params[:l].to_i > 0 ? [MAX_LIMIT, params[:l].to_i].min : MAX_LIMIT 
		offset = params[:o].to_i

		@owners = Owner.search(params[:q], offset, limit)
	end
end