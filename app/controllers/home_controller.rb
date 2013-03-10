#encoding: utf-8
class HomeController < ApplicationController

	def about
		@title = t('home.show.what_is')
		@titletext = t('home.show.what_is_desc')
		@color = "#490a3d"
		@back = true		
	end

	def contact
		@title = t('home.contact.title')
		@titletext = t('home.contact.desc')
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