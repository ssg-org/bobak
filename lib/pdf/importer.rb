require 'csv'
require 'singleton'

module PDF
  class Importer
    include Singleton

    # Import data from PDF
    def import(date, file, min_page = 0, max_page)

    	puts "Importing data from: #{file}"

      # Load date
      @date = date

      # Regex patterns
      id_regex = /^(0|\d{6,9}|\d{12,13}|X{13}|UPI\d{8,10}(?:\/\d)?|U\/I-\d{4}\/\d{2}|UF\/I\d{4}\/\d{2}|\d{2,3}-\d{1,7}-\d{1,7}(?:[\/|\-|\s]\d{1,4})?)$/

      # output dir
      out_dir = File.join(Rails.root, "db", "export")
      Dir.mkdir(out_dir) if !Dir.exist?(out_dir)

      @banks = Set.new

      # Output CSV files
      @result_csv = CSV.open(File.join(out_dir, "#{date}.csv"), "w")

      owner_lines = []

      # Statistics
      @total = {}
      @total.default = 0

      @cases = [0, 0, 0, 0, 0, 0]

      start = Time.now
    	PDF::Reader.new(file).pages.each_with_index do |page, page_num|
    		#Skip first min_page
        next if page_num < min_page

        # Stop after max_page 
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
    def clean(name)
      name
        .gsub('"','')
        .gsub('D.D.', 'DD')
        .gsub('D.O.O.', 'DOO')
    end

    def get_bank (line)
      return @banks.select{|bank| line.ends_with?(bank)}.first
    end

    def save(id, account_id, name, bank)
      special_ids = Set.new ["0", "00000000", "0000000000000", "1111111111111", "7777777777777", "9999999999999", "XXXXXXXXXXXXX"]

      # Store bank in memory
      @banks.add(bank) if !@banks.include?(bank)

      @result_csv << [special_ids.include?(id) ? nil : id, account_id, clean(name), bank]
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

        # Fix the case when there is not \t between name and bank
        if data.size == 2 && bank = get_bank(data[1])
          data << data[1].rpartition(bank).delete_if(&:empty?)
          data.delete_at(1)
        # Fix for case whern there are more then 3 \t inside line
        elsif data.size > 3 && bank = get_bank(data[-1])
          p "> 3: Before #{data}"
          data = [data[0], data[1..-2].join(' '), data[-1]]
          p "> 3: After #{data}"
        end          

        # Line with account
        if (data.size == 3 && !tmp.empty?)
          records << tmp
          tmp = []
        end
        
        tmp << data
      end

      records.push(tmp) if !tmp.empty?

      records.each do |account|

        # Case 1: owner has only 1 account and its single line
        if account.size == 1 && account.first.size == 3
          @cases[1] += 1
          
          save(id, account.first[0], account.first[1], account.first[2])
          #p "#{id}, #{account.first[0]}, #{account.first[1]}, #{account.first[2]}"
        # Case 2: one account split into 2 lines - first line: name and bank, 2nd line is account ID
        elsif account.size == 2 && (account.flatten.size == 3)
          #p "Reversed: #{account.reverse.flatten}"
          @cases[2] += 1

          full_line = account.reverse.flatten
          save(id, full_line[0], full_line[1], full_line[2])
        elsif account.flatten.size == 3
          # sace when bank is in seprate line
          account = account.flatten          
          save(id, account[0], account[1], account[2])
        else
          @cases[3] += 1
          # find line with all info
          account_info = account.select {|line| line.size == 3}

          # there is only 1 line with
          if account_info.size == 1
            @cases[4] += 1
            #p "#{id}, #{account_info.first[0]}, #{account_info.first[2]}, #{name}"

            name = [account_info.first[1], (account - account_info).flatten].join(' ')
            save(id, account_info.first[0], name, account_info.first[2])
          else
            # We need to find id and bank manually
            @cases[5] += 1

            account = account.flatten

            account_id = account.select {|e| e =~ /\d{16}/}.first
            bank = account.select {|e| @banks.include?(e)}.first

            # we know id and bank
            if account_id && bank
              account -= [account_id, bank]
              save(id, account_id, account.join(' '), bank)
            else
              p "Unrecognized pattern found: #{account_info} - #{account}"
            end
          end
        end
      end
    end
  end
end