#encoding: utf-8
module Reporting
  class Builder
    def top_banks_by_accounts(limit, date)
      report = Report.new().add_column('Banka').add_column('Broj računa', 'number')

      BankSummary.get_top_banks_by_accounts(limit, date).each do |summary|
        report.add_row([summary.bank.name, summary.blocked_accounts])
      end

      return report.to_json
    end

    def top_banks_by_owners(limit, date)
      report = Report.new().add_column('Banka').add_column('Broj vlasnika', 'number')

    	BankSummary.get_top_banks_by_owners(limit, date).each do |summary|
    		report.add_row([summary.bank.name, summary.blocked_owners])
    	end

    	return report.to_json
    end

    def top_owners_by_accounts(limit, date)
    	report = Report.new().add_column('Vlasnik').add_column('Broj računa', 'number')

    	OwnerSummary.top_owners_by_accounts(limit, date).each do |summary|
    		report.add_row([summary.owner.name, summary.blocked_accounts])
    	end

    	return report.to_json
    end
  end
end