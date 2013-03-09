#encoding: utf-8
require 'reporting'

class ReportsController < ApplicationController
	def show
		@title = "STATISTIKE"
		@titletext = "Iz mjeseca u mjesec mi uzimamo nove podatke od Centralne Banke Bosne i Hercegovine te ih spašavamo i generišemo različite statistike."
		@color = "#f8ca00"	
		@back = true

		month = Time.now.month

		case params[:t]
		when 'by_accounts'
			@report = Reporting::Builder.new().top_banks_by_accounts(10, month)
		when 'by_owners'
			@report = Reporting::Builder.new().top_banks_by_owners(10, month)
		else 
			#'all'
			@report_banks = Reporting::Builder.new().top_banks_all(10, month)
			@report_owners = Reporting::Builder.new().top_owners_by_accounts(10, month)
		end	
	end
end