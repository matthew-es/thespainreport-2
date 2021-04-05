module Patrons
    class CreateInvoice
        def self.process(payment)

		how_many_invoices = Invoice.all.where(invoice_year: Time.current.year).count
		invoice_number = "SPAIN-" + Time.current.year.to_s + '-' + (how_many_invoices + 1).to_s.rjust(8, '0')
		
		invoice = Invoice.create(
			account_id: payment.account.id,
			subscription_id: payment.subscription.id,
			plan_amount: payment.subscription.plan_amount,
			tax_percent: payment.subscription.vat_rate,
			invoice_tax_country: "",
			tax_amount: payment.subscription.vat_amount,
		    total_amount: payment.subscription.total_amount,
		    invoice_number: invoice_number,
		    invoice_year: Time.now.year,
		    invoice_month: Time.now.month,
		    invoice_day: Time.now.day,
		    invoice_customer_name: payment.account.invoice_account_name,
		    invoice_customer_tax_id: payment.account.invoice_account_tax_id,
		    invoice_customer_address: payment.account.invoice_account_address,
		    invoice_concept: "Independent journalism. Periodismo independiente.",
		    invoice_from_name: "Matthew Bennett",
		    invoice_from_tax_id: "X3630511F",
		    invoice_from_address: "Avenida Príncipe de Asturias 42, 3C, 30007 Murcia",
		    invoice_status: true
			)
		
		payment.update(
			invoice_id: invoice.id
			)

        end
    end
end