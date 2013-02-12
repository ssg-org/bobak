require 'pdf-reader'
require "CSV"

module PDF
  class Importer

    # Import data from PDF
    def import(date = Time.now, file, max_page)

    	puts "Importing data from: #{file}"

      # Regex patterns
      id_regex = /^(\d{6}|\d{8}|\d{12}|\d{13}|X{13}|UPI\d{10})$/

      # output dir
      out_dir = File.join(Rails.root, "db", "export", date)
      Dir.mkdir(out_dir) if !Dir.exist?(out_dir)

      # CSV headers
      banks_headers = ['id', 'name']
      companies_headers = ['id', 'jib', 'name']
      accounts_headers = ['id', 'company_id', 'bank_id', 'account', 'name']

      # Output CSV files
      @companies_csv = CSV.open(File.join(out_dir, "companies.csv"),"w")
      @accounts_csv = CSV.open(File.join(out_dir, "accounts.csv"), "w")
      @banks_csv = CSV.open(File.join(out_dir, "banks.csv"), "w")
      @skipped_csv = CSV.open(File.join(out_dir, "skipped.csv"), "w")

      # Write headers - previous code does not work
      @companies_csv << companies_headers
      @banks_csv << banks_headers
      @accounts_csv << accounts_headers

      firm_lines = []

      # Array of all banks
      @banks=[]

      # Statistics
      @total = {
        :pages => 0,
        :companies_read => 0,
        :companies_saved => 0,
        :accounts_saved => 0,
        :accounts_skipped => 0,
        :banks => 0
      }

      start = Time.now
    	PDF::Reader.new(file).pages.each_with_index do |page, page_num|
    		
    		break if page_num > max_page

        @total[:pages] += 1

  			page.text.lines.each do |line|
          # skip empty lines
  				if !line.strip!.blank?

  					# Match company ID - this is new company
  					if line =~ id_regex
  						# parse and save company info but skip first time
  						save (firm_lines) if !firm_lines.empty?

  						# start capturing data for new company
  						firm_lines = [$~[1]]
            # skip strings which are not accounts: headers and footers
  					elsif !(line =~ /Broj racuna/i || line =~ /^\d{2}\/\d{2}\/\d{4}/ || line =~ /^JIB/) && (!firm_lines.empty?)
  						firm_lines << line.gsub(/\s{2,}/,'\t')
  					end
  				end
  			end
  		end

      @companies_csv.close
      @accounts_csv.close
      @banks_csv.close
      @skipped_csv.close

      puts "Statistics: #{@total.to_yaml}"
      puts "Loading finished in: %3d:%04.2f"%(Time.now-start).divmod(60.0)
  	end

    private
    def save(lines)
      @total[:companies_read] += 1
      puts "#Loaded: #{@total[:companies_read]}" if @total[:companies_read] % 1000 == 0

      # match company ID is always first line in array
      id = lines[0]
      accounts = []
      names = []
      banks = []

      # Parse account, name and bank iformation
      lines[1..-1].each_with_index do |line, index|
        data = line.split('\t')
        # is this full line with account, name and bank
        if data.size == 3
          accounts << data[0]
          names << data[1]
          banks << data[2]
        # this is potenrially second line of the account name
        elsif (data.size == 1 && names.length > 0)
          names[-1] += " #{line}"

        #something is wrong here!!!
        elsif (data.size == 2)
          # Check 1: is bank part of the company name
          @banks.each do |bank|

            # we have found the bank in the name
            if data[1].ends_with?(bank)
              accounts << data[0]
              names << data[1].gsub(bank,"").strip
              banks << bank

              puts "\tFixed by spliting bank from name"
            end
          end
        # There are only 3 lines: id, name and bank split
        elsif (lines.size==3 && ((lines[1] + lines[2]).count('\t')==1 || (lines[1] + lines[2]).count('\t')==2))
          #check if lines need to be joined with '\t'
          joined_line = (lines[1] + lines[2]).count('\t') == 1 ? [lines[2], lines[1]].join('\t') : [lines[2], lines[1]].join
          
          data = joined_line.split('\t')
          accounts << data[0]
          names << data[1]
          banks << data[2]
          puts "\tFixed by reversing and joining lines"
        else

          puts "\tWarning: Skipping account because of incorect order! #{line}"
          @skipped_csv << [index,lines]
          @total[:accounts_skipped] += 1
        end
      end

      # Take first name of accounts as firm name
      @total[:companies_saved] += 1
      @companies_csv << [@total[:companies_saved], id, names.compact.first]

      # Add all acounts
      accounts.each_index do |i|
        # Add bank if missing
        if !@banks.include?(banks[i])
          @total[:banks] += 1
          @banks << banks[i]
          @banks_csv << [@total[:banks], banks[i]]
        end

        @total[:accounts_saved] += 1
        @accounts_csv << [@total[:accounts_saved], @total[:companies_saved], @banks.index(banks[i])+1, accounts[i], names[i]]
      end
    end
  end
end