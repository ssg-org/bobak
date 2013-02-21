namespace :registar do
	namespace :firms do
		
		desc "Populate firm names from accounts"
		task :populate_names => :environment do
			Firm.all.each do |firm| 
				# Populate only firms without names
				if firm.name.blank? && firm.accounts.length > 0
					if firm.accounts.count == 1
						firm.name = firm.accounts.first.name
					else
						# figure out which name is best to select
						# for now it is first name
						firm.name = firm.accounts.first.name					
					end
					firm.save
				end
			end
		end
	end
end