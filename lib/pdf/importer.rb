require "CSV"
require 'singleton'

module PDF
  class Importer
    include Singleton

    # Import data from PDF
    def import(date, file, max_page)

    	puts "Importing data from: #{file}"

      # Load date
      @date = date

      # Regex patterns
      id_regex = /^(\d{6}|\d{8}|\d{12}|\d{13}|X{13}|UPI\d{10}|U\/I-\d{4}\/\d{2}|UF\/I\d{4}\/\d{2})$/

      # output dir
      out_dir = File.join(Rails.root, "db", "export")
      Dir.mkdir(out_dir) if !Dir.exist?(out_dir)

      # Output CSV files
      @result_csv = CSV.open(File.join(out_dir, "#{date}.csv"), "w")

      owner_lines = []

      # Statistics
      @total = {}
      @total.default = 0

      @cases = [0, 0, 0, 0, 0, 0]

      start = Time.now
    	PDF::Reader.new(file).pages.each_with_index do |page, page_num|
    		
    		break if page_num > max_page

        @total[:pages] += 1

  			page.text.lines.each do |line|
          # skip empty lines
  				if !line.strip!.blank?

  					# Match owner ID - this is new owner
  					if line =~ id_regex
  						# parse and save owner info but skip first line
  						parse(owner_lines) if !owner_lines.empty?

  						# start capturing data for new owner
  						owner_lines = [$~[1]]
            # skip strings which are not accounts: headers and footers
  					elsif !(line =~ /Broj racuna/i || line =~ /^\d{2}\/\d{2}\/\d{4}/ || line =~ /^JIB/) && (!owner_lines.empty?)
  						owner_lines << line.gsub(/\s{2,}/,'\t')
  					end
  				end
  			end
  		end

      @result_csv.close

      puts "Statistics: #{@total.to_yaml}\n#{@cases}"
      puts "Loading finished in: %3d:%04.2f"%(Time.now-start).divmod(60.0)
  	end

    private
    def special_id? (id)
      return id =~ /^(0|[1|7|9|X]{5})$/
    end

    def save(id, account_id, name, bank)
      #p "#{id}, #{account_id}, #{name}, #{bank}"
      @result_csv << [id, account_id, name, bank]
    end

    def parse(lines)
      @total[:owners_read] += 1
      puts "#Loaded: #{@total[:owners_read]}" if @total[:owners_read] % 1000 == 0

      # match owner ID is always first line in array
      id = lines[0]
      accounts = []
      names = []
      banks = []

      records = []
      tmp = []

      # Parse account, name and bank iformation
      lines[1..-1].each_with_index do |line, index|
        data = line.split('\t')

        # Line with account
        if data.size == 3 && !tmp.empty?
          records << tmp
          tmp = []
        end
        
        tmp << data
      end

      records.push(tmp) if !tmp.empty?

      records.each do |account|
        isSpecial = special_id? id

        # Case 1: owner has only 1 account and its single line
        if account.size == 1 && account.first.size == 3
          @cases[1] += 1
          
          save(isSpecial ? nil : id, account.first[0], account.first[1], account.first[2])
          #p "#{id}, #{account.first[0]}, #{account.first[1]}, #{account.first[2]}"
        # Case 2: one account split into 2 lines - first line: name and bank, 2nd line is account ID
        elsif account.size == 2 && (account.flatten.size == 3)
          #p "Reversed: #{account.reverse.flatten}"
          @cases[2] += 1

          full_line = account.reverse.flatten
          save(isSpecial ? nil : id, full_line[0], full_line[1], full_line[2])
        else
          @cases[3] += 1
          # find line with all info
          account_info = account.select {|line| line.size == 3}

          # there is only 1 line with
          if account_info.size == 1
            @cases[4] += 1
            #p "#{id}, #{account_info.first[0]}, #{account_info.first[2]}, #{name}"

            name = [account_info.first[1], (account - account_info).flatten].join(' ')
            save(isSpecial ? nil : id, account_info.first[0], name, account_info.first[2])
          else
            @cases[5] += 1
            p "Multiple info lines: #{account_info} - #{account}"
          end
        end
      end
    end
  end
end