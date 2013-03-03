#encoding: utf-8
class ContactsController < ApplicationController
	def show
		@title = "KONTAKT"
		@titletext = "Ako imate nekih pitanja slobodno kontaktirajte Sredi Svoj Grad tim."
		@color = "#8a9b0f"
		@back = true
	end
end