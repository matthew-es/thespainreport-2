module Patrons
    class CreateInvoiceExchange
        def self.process(invoice)

			how_many_invoices = Invoice.all.where(invoice_year: Time.current.year, invoice_type: "full").count
			invoice_number = "CO-" + Time.current.year.to_s + '-' + (how_many_invoices + 1).to_s.rjust(8, '0')
			
			invoice_new = Invoice.create(
				original_id: invoice.id,
				payment_id: invoice.payment.id,
				account_id: invoice.account.id,
				subscription_id: invoice.payment.subscription.id,
				tax_percent: invoice.payment.subscription.vat_rate,
				invoice_tax_country: invoice.payment.subscription.vat_country,
				plan_amount: invoice.plan_amount,
				tax_amount: invoice.tax_amount,
			    total_amount: invoice.total_amount,
			    invoice_number: invoice_number,
			    invoice_year: Time.now.year,
			    invoice_month: Time.now.month,
			    invoice_day: Time.now.day,
			    invoice_type: "full",
			    invoice_operation: "exchange",
			    invoice_customer_name: invoice.account.invoice_account_name,
			    invoice_customer_tax_id: invoice.account.invoice_account_tax_id,
			    invoice_customer_address: invoice.account.invoice_account_address,
			    invoice_concept: "Exchange invoice: simple to full // Factura de canje: simplificada a completa",
			    invoice_from_name: "Matthew Bennett",
			    invoice_from_tax_id: "X3630511F",
			    invoice_from_address: "Avenida Príncipe de Asturias 42, 3C, 30007 Murcia",
			    invoice_status: true
			)
			
			how_many_invoices_2 = Invoice.all.where(invoice_year: Time.current.year, invoice_type: "simple").count
			invoice_number_2 = "SI-" + Time.current.year.to_s + '-' + (how_many_invoices_2 + 1).to_s.rjust(8, '0')
			
			invoice_new_2 = Invoice.create(
				original_id: invoice.id,
				payment_id: invoice.payment.id,
				account_id: invoice.account.id,
				subscription_id: invoice.payment.subscription.id,
				tax_percent: invoice.payment.subscription.vat_rate,
				invoice_tax_country: invoice.payment.subscription.vat_country,
				plan_amount: -invoice.plan_amount,
				tax_amount: -invoice.tax_amount,
			    total_amount: -invoice.total_amount,
			    invoice_number: invoice_number_2,
			    invoice_year: Time.now.year,
			    invoice_month: Time.now.month,
			    invoice_day: Time.now.day,
			    invoice_type: "simple",
			    invoice_operation: "exchange",
			    invoice_concept: "Exchange invoice: simple to full // Factura de canje: simplificada a completa",
			    invoice_from_name: "Matthew Bennett",
			    invoice_from_tax_id: "X3630511F",
			    invoice_from_address: "Avenida Príncipe de Asturias 42, 3C, 30007 Murcia",
			    invoice_status: true
			)

        end
    end
end