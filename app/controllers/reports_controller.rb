#encoding: utf-8
class ReportsController < ApplicationController
	def show
		@title = "STATISTIKE"
		@titletext = "Iz mjeseca u mjesec mi uzimamo nove podatke od Centralne Banke Bosne i Hercegovine te ih spašavamo i generišemo različite statistike."
		@color = "#e97f02"	
		@back = true
	end
end