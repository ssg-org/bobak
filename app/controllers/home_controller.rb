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
		@titletext = "Bobak je sistem za pretraživnje firmi u Bosni i Hercegovini koje imaju blokirane račune u bh bankama."
		@color = "#490a3d"
		@back = true		
	end

	def contact
		@title = "KONTAKT"
		@titletext = "Ako imate nekih pitanja slobodno kontaktirajte Sredi Svoj Grad tim."
		@color = "#8a9b0f"
		@back = true

		if params[:name] && params[:email] && params[:message]
			begin
				ContactMailer.inquiry_email(params[:name], params[:email], params[:message]).deliver
			rescue Exception => ex
				p "Error while sending email: #{ex.message}"
				p "Trace: #{ex.backtrace.join('\n')}"
				redirect_to root_path()
			end
		end

		# FIX THIS
		redirect_to root_path() if params[:method] == 'POST'
	end
end