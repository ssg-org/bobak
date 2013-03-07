#encoding: utf-8
class AboutsController < ApplicationController
	def show
		@title = "ŠTA JE BOBAK?"
		@titletext = "Bobak je servis za pretraživnje firmi u Bosni i Hercegovini koje imaju blokirane račune u bh bankama."
		@color = "#490a3d"
		@back = true
	end
end