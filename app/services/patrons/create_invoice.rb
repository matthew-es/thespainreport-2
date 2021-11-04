module Patrons
    class CreateInvoice
        def self.process(payment)
        
        puts "CREATE INVOICE -- INSIDE"
        
        if payment.account.invoice_account_name.blank? || payment.account.invoice_account_tax_id.blank? || payment.account.invoice_account_address.blank?
        	type = "simple"
        else
        	type = "full"
        end
        
        puts "CREATE INVOICE -- TYPE IS: " + type.to_s
        
        operation = "payment"
        
        case type when "simple"
			how_many_invoices = Invoice.all.where(invoice_year: Time.current.year, invoice_type: "simple").count
			invoice_number = "SI-" + Time.current.year.to_s + '-' + (how_many_invoices + 1).to_s.rjust(8, '0')
			
			puts "CREATE INVOICE -- HOW MANY IS: " + how_many.to_s
			puts "CREATE INVOICE -- INVOICE NUMBER IS: " + invoice_number.to_s
			
			invoice = Invoice.create(
				payment_id: payment.id,
				account_id: payment.account.id,
				subscription_id: payment.subscription.id,
				tax_percent: payment.subscription.vat_rate,
				invoice_tax_country: payment.subscription.vat_country,
				plan_amount: payment.base_amount,
				tax_amount: payment.vat_amount,
			    total_amount: payment.total_amount,
			    invoice_number: invoice_number,
			    invoice_year: Time.now.year,
			    invoice_month: Time.now.month,
			    invoice_day: Time.now.day,
			    invoice_type: type,
			    invoice_operation: operation,
			    invoice_concept: "Independent journalism. Periodismo independiente.",
			    invoice_from_name: "Matthew Bennett",
			    invoice_from_tax_id: "X3630511F",
			    invoice_from_address: "Avenida Príncipe de Asturias 42, 3C, 30007 Murcia",
			    invoice_status: true
			)
        when "full"
			how_many_invoices = Invoice.all.where(invoice_year: Time.current.year, invoice_type: "full").count
			invoice_number = "CO-" + Time.current.year.to_s + '-' + (how_many_invoices + 1).to_s.rjust(8, '0')
			
			invoice = Invoice.create(
				payment_id: payment.id,
				account_id: payment.account.id,
				subscription_id: payment.subscription.id,
				tax_percent: payment.subscription.vat_rate,
				invoice_tax_country: payment.subscription.vat_country,
				plan_amount: payment.base_amount,
				tax_amount: payment.vat_amount,
			    total_amount: payment.total_amount,
			    invoice_number: invoice_number,
			    invoice_year: Time.now.year,
			    invoice_month: Time.now.month,
			    invoice_day: Time.now.day,
			    invoice_type: type,
			    invoice_operation: operation,
			    invoice_customer_name: payment.account.invoice_account_name,
			    invoice_customer_tax_id: payment.account.invoice_account_tax_id,
			    invoice_customer_address: payment.account.invoice_account_address,
			    invoice_concept: "Independent journalism. Periodismo independiente.",
			    invoice_from_name: "Matthew Bennett",
			    invoice_from_tax_id: "X3630511F",
			    invoice_from_address: "Avenida Príncipe de Asturias 42, 3C, 30007 Murcia",
			    invoice_status: true
			)
		when "correction"
			how_many_invoices = Invoice.all.where(invoice_year: Time.current.year, invoice_type: "correction").count
			invoice_number = "RE-" + Time.current.year.to_s + '-' + (how_many_invoices + 1).to_s.rjust(8, '0')
		else end
		
		
		payment.update(
			invoice_id: invoice.id
			)

        end
    end
end