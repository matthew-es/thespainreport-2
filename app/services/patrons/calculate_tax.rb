module Patrons
    class CalculateTax
        def self.process(account, amount)
            puts amount
            puts account
            
            country = Country.find_by(country_code: account.vat_country)
		    puts country
		    
    		if country.nil?
    			tax_rate = 0
    		else
    			applicable_tax_country = Country.find_by(country_code: "ES")
    			tax_rate = applicable_tax_country.tax_percent
    		end
            
            puts tax_rate
            
            tax_calc = amount.to_f * tax_rate
    		puts tax_calc
    		
    		total_calc = amount.to_f + tax_calc
    		puts total_calc
    		
    		tax_amount = tax_calc.round
    		puts tax_amount
    		
    		total_amount = total_calc.round
            puts total_amount
            
            {"tax_rate" => tax_rate, "tax_amount" => tax_amount, "total_amount" => total_amount}
        end
    end
end