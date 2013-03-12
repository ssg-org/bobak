require 'nokogiri'
require 'open-uri'

jibs = [
	4227093300008,
	4400935910008,
	4402618340002,
	4200198750003,
	4401230080002,
	4600013160009,
	4400706990006,
	4272097770004,
	4209058160009,
	4402089170007,
	4402501230001,
	4401351890001,
	4600100720002,
	4236009430006,
	4236006920002,
	4400373570004,
	4263552810002,
	4218428690001,
	4272080960004,
	4200341060005,
	4401707740000,
	4400862850001,
	4200752440003,
	4200341060005,
	4400756580003,
	4227064030000,
	4272014660008,
	4401116540001,
	4401372030002,
	4402001340005,
	4201055340005,
	4400517320008,
	4402783460004,
	4201283990001,
	4401775230001,
	4400754880000,
	4218264130000,
	4200034560009,
	4236070850000,
	4401567040002
]



def search(jib)
	doc = Nokogiri::HTML(open("http://isrmsp.gov.ba/?cat=&s=#{jib}"))

	if (doc.css('#itemsbox').length > 0) 
		li_id = doc.css('#itemsbox').first.children.first.attr('id')
		firm_id = li_id.split('_').last

		firm_doc = Nokogiri::HTML(open("http://isrmsp.gov.ba/?p=#{firm_id}"))
		data = firm_doc.css('.article > p').first.content

		naziv = data.match('(Naziv.*:)(.*)\n')[2]
		jib = data.match('(JIB.*:)(.*)\n')[2]
		aktivnost = data.match('(Aktivnost.*:)(.*)\n')[2]
		zaposlenih = data.match('(Broj zaposlenika.*:)(.*)\n')[2]
		tip = data.match('(Tip .*:)(.*)\n')[2]
		reg = data.match('(Registracijski broj.*:)(.*)\n')[2]
		stanje = data.match('(Stanje.*:)(.*)\n')[2]
		datum_reg = data.match('(Datum registracije.*:)(.*)\n')[2]
		tp_vlasnistva = data.match('(Tip vlasnistva.*:)(.*)\n')[2]
		adresa = data.match('(Adresa.*:)(.*)')[2]
		opstina = firm_doc.css('.customfieldsoutput > .f_half > a').first.content

		puts "Naziv          : #{naziv.strip}"
		puts "Aktivnost      : #{aktivnost.strip}"
		puts "Br. Zaposlenih : #{zaposlenih.strip}"
		puts "Tip            : #{tip.strip}"
		puts "Reg. Broj      : #{reg.strip}"
		puts "Stanje         : #{stanje.strip}"
		puts "Datum Reg.     : #{datum_reg.strip}"
		puts "Tip vlasnistva : #{tp_vlasnistva.strip}"
		puts "Adresa         : #{adresa.strip}"
		puts "Opstina        : #{opstina.strip}"


	end
end

jibs.each do |jib| 
	puts "------------- #{jib} ---------------"
	search(jib)
end