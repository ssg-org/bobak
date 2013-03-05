ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => ENV['aws_key'],
  :secret_access_key => ENV['aws_secret']