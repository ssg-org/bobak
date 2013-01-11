require 'pdf-reader'

namespace :pdf do
  desc "Import data from PDF file"
  task :import, [:date, :file, :max_page] => :environment do |t, args|
  	args.with_defaults(:date => DateTime.now)

  	date = args.date.to_datetime
  	file = args.file
  	max_page = args.max_page.to_i

  	if (date.blank? || file.blank?)
  		raise "Missing prameters. Run task: rake pdf:import[31-12-2012,racuni.pdf]"
  	end

  	puts "Importing data from: #{file}"

  	reader = PDF::Reader.new(file)

  	banks = {}
  	firm = nil
  	line_num = 0
  	page_num = 0
  	log = false

  	reader.pages.each { |page|
  		
  		if ((page_num += 1) > max_page)
  			break
  		end

		page.text.lines.each { |line|


			if line.match /MARKET SCHOP 24 STR/
				log = true
			elsif line.match /DOBOJPUTEVI AD DOBOJ/
				log = false
			end
			
			puts line if log

		if !line.strip!.blank?

			# Match company name - this is new company
			/^(\d{12,13})$/.match(line) {|match|
				# Save previous firm
				if !firm.nil?
					puts "Adding new firm: #{firm.to_json}"
					firm.save!
				end

				firm = Firm.new
				firm.date = date
				firm.is_insolvent = false
				firm.jib = match[1]
				accounts = []
			}

			# Extract accounts
			/^(\d{16})\s{2,}(.*\b)\s{2,}(.*)$/.match(line) {|match|

				# New account for existing firm
				account = Account.new
				account.date = date
				account.number = match[1]
				account.name = match[2]

				# Check bank
				bank_name = match[3]
				bank = banks[bank_name]
				if (bank.nil?)
					bank = Bank.new
					bank.name = bank_name
					puts "Adding new bank: #{bank.to_json}"
					bank.save

					banks[bank_name] = bank
				end

				# Set bank
				account.bank = bank

				# Add account to firm
				firm.accounts << account
			}
		end
		}
  	}

	if !firm.nil?
		firm.save!
	end
end

end
4000000400719