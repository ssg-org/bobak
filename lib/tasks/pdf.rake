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

  	firm_lines = []

  	firm = nil
  	line_num = 0

  	reader.pages.each_with_index do |page, page_num|
  		
  		break if page_num > max_page

			page.text.lines.each do |line|
				if !line.strip!.blank?

					# Match company name - this is new company
					if match = /^(\d{12,13})$/.match(line)
						
						# parse and save company info
						save (firm_lines)

						# new company
						firm_lines = [match[1]]
					else
						firm_lines << line
					end
				end
			end
		end
	end
end