#encoding: utf-8
module Reporting
  class Builder
    def top_banks_by_accounts(limit, month)
      report = Report.new().add_column('Banka').add_column('Broj računa', 'number')

      BankSummary.get_top_banks_by_accounts(limit, month).each do |summary|
        report.add_row([summary.bank.name, summary.blocked_accounts])
      end

      return report.to_json
    end

    def top_banks_by_owners(limit, month)
      report = Report.new().add_column('Banka').add_column('Broj vlasnika', 'number')

    	BankSummary.get_top_banks_by_owners(limit, month).each do |summary|
    		report.add_row([summary.bank.name, summary.blocked_owners])
    	end

    	return report.to_json
    end

    def top_owners_by_accounts(limit, month)
    	report = Report.new().add_column('Firma').add_column('Računa')

    	OwnerSummary.top_owners_by_accounts(limit, month).each do |summary|
    		report.add_row([summary.owner.name, summary.blocked_accounts])
    	end

    	return report.to_json
    end

    def top_banks_all(limit, month)
      report = Report.new().add_column('Banka').add_column('Broj računa', 'number').add_column('Broj firmi', 'number')

      BankSummary.get_top_banks(limit, month).each do |summary|
        report.add_row([summary.bank.name, summary.blocked_accounts, summary.blocked_owners])
      end

      return report.to_json
    end

  end
end