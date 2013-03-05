class ContactMailer < ActionMailer::Base
  default :to 	=> "bobak-contact@sredisvojgrad.org",
  				:from => "bobak-contact@sredisvojgrad.org"

  def inquiry_email(name, email, message)
  	@name = name
  	@email = email
  	@message = message
  	
  	mail(:subject => "Question: #{name}")
  end
end
