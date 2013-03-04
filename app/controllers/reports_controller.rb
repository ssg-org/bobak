#encoding: utf-8
require 'reporting'

class ReportsController < ApplicationController
	def show
		@title = "STATISTIKE"
		@titletext = "Iz mjeseca u mjesec mi uzimamo nove podatke od Centralne Banke Bosne i Hercegovine te ih spašavamo i generišemo različite statistike."
		@color = "#f8ca00"	
		@back = true

		date = '2013-01-03'

		case params[:t]
		when 'by_accounts'
			@report = Reporting::Builder.new().top_banks_by_accounts(10, date)
		when 'by_owners'
			@report = Reporting::Builder.new().top_banks_by_owners(10, date)
			#@report2 = Reporting::Builder.new().top_owners_by_accounts(10, date)
		else 
			#'all'
			@report_banks = Reporting::Builder.new().top_banks_all(10, date)
			@report_owners = Reporting::Builder.new().top_owners_by_accounts(10, date)
		end	
	end
end