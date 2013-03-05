#encoding: utf-8
class HomeController < ApplicationController
	def show
		@title = ""
		@titletext = ""
		@color = "#e1e1e1"
		@back = false
	end

	def about
		@title = "ŠTA JE BOBAK?"
		@titletext = "Bobak je sistem za pretraživnje firmi u Bosni i Hercegovini koje imaju blokirane racune u bh bankama."
		@color = "#490a3d"
		@back = true		
	end

	def contact
		@title = "KONTAKT"
		@titletext = "Ako imate nekih pitanja slobodno kontaktirajte Sredi Svoj Grad tim."
		@color = "#8a9b0f"
		@back = true

		p params

		if params[:name] && params[:email] && params[:message]
			ContactMailer.inquiry_email(params[:name], params[:email], params[:message])
		end
	end
end