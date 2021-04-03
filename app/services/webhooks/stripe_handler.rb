module Webhooks
    class StripeHandler
        def self.process(event)
            case event.data["type"]
                when 'setup_intent.setup_failed'
                    puts "Card set up failed"
                when 'payment_intent.requires_action'    
                    puts "Payment requires SCA action"
                when 'payment_intent.requires_payment_method'
                    puts "Something wrong with the card..."
                when 'payment_intent.payment_failed'
                    w_payment_id = event["data"]["data"]["object"]["id"] ? event["data"]["data"]["object"]["id"] : "No id"
                    w_payment_obj = event["data"]["data"]["object"]["object"] ? event["data"]["data"]["object"]["object"] : "No object"
                    w_payment_decline_code = event["data"]["data"]["object"]["last_payment_error"]["decline_code"] ? event["data"]["data"]["object"]["last_payment_error"]["decline_code"] : "No code"
                    w_payment_amount = event["data"]["data"]["object"]["amount"] ? event["data"]["data"]["object"]["amount"]/100.to_f : "0"
                    w_payment_status = event["data"]["data"]["object"]["status"] ? event["data"]["data"]["object"]["status"] : "No status"
                    w_payment_error_message = event["data"]["data"]["object"]["last_payment_error"]["message"] ? event["data"]["data"]["object"]["last_payment_error"]["message"] : "No error message"
                    w_payment_customer = event["data"]["data"]["object"]["customer"] ? event["data"]["data"]["object"]["customer"] : "No customer"
                    
                    payment = Payment.find_by(external_payment_id: w_payment_id)
                    payment_id = payment.id
                    payment.update(
                        external_payment_status: w_payment_status
                        )
                    payment_money_word_singular = payment.subscription.frame.money_word_singular
                    payment_money_word_plural = payment.subscription.frame.money_word_plural 
                    
                    PaymentError.create(
						payment_id: payment_id,
						payment_error_object: w_payment_obj,
						payment_error_status: w_payment_status,
						payment_error_code: w_payment_decline_code,
						payment_error_message: w_payment_error_message,
						payment_error_source: "stripe-webhook"
						)
                    
                    account = Account.find_by(stripe_customer_id: w_payment_customer)
                    account_email = account.user.email
                    account_id = account.id
                    
                    user = "matbenet77@gmail.com"
                    user_subject = "Problem with your #{payment_money_word_singular} of €#{w_payment_amount}: it's easy to fix"
                    user_message = (
                        "There was a problem with your #{payment_money_word_singular}. It is easy to fix." + "<br /><br />" + 
                        "<a href=\"https://www.thespainreport.com/#{account_id}\">Click this link to confirm this #{payment_money_word_singular}</a>" + "<br /><br />" + 
                        "Your account ID: #{account_id}" + "<br />" +
                        "Your email: #{account_email}" + "<br />" +
                        "Amount: €#{w_payment_amount}" + "<br />" +
                        "Status: #{w_payment_status}" + "<br />" + 
                        "Code: #{w_payment_decline_code}" + "<br />" +
                        "Problem: #{w_payment_error_message}" + 
                        "<br /><br />" + 
                        "All of the regular #{payment_money_word_plural} from hundreds of reader patrons really do add up to make this possible." + "<br /><br />" +
                        "More facts, reality, truth and context about how Spain is really changing." + "<br /><br />" + 
                        "<a href=\"https://www.thespainreport.com/#{account_id}\">Click this link to confirm this #{payment_money_word_singular}</a>"
                        ).html_safe
                    UserMailer.user_alert(user, user_subject, user_message).deliver_now
                    
                    admin_subject = "Problem with payment of €#{w_payment_amount} from #{account_email}"
                    admin_message = (
                         "Stripe event ID: #{event.data["id"]}" + "<br />" + 
                         "Stripe payment ID: #{w_payment_id}" + "<br />" + 
                         "Stripe customer ID: #{w_payment_customer}" + "<br />" +
                         "Customer email: #{account_email}" + "<br />" +
                         "TSR account ID: #{account_id}" + "<br />" +
                         "TSR payment ID: #{payment_id}" + "<br />" +
                         "Type: #{event.data["type"]}" + "<br />" + 
                         "Amount: €#{w_payment_amount}" + "<br />" + 
                         "Status: #{w_payment_status}" + "<br />" + 
                         "Code: #{w_payment_decline_code}" + "<br />" +
                         "Problem: #{w_payment_error_message}"
                        ).html_safe
                    UserMailer.admin_alert(admin_subject, admin_message).deliver_now
                    
                when 'payment_intent.succeeded'
                    stripe_event_id = event.data["id"]
                    stripe_event_type = event.data["type"]
                    stripe_object_id = event.data["data"]["object"]["id"]
                    stripe_object_status = event.data["data"]["object"]["status"]
                    stripe_customer_id = event.data["data"]["object"]["customer"]
                    
                    amount = event["data"]["data"]["object"]["amount"] ? event["data"]["data"]["object"]["amount"]/100.to_f : "0"
                    
                    account = Account.find_by(stripe_customer_id: stripe_customer_id)
                    account_id = account.id
                    account_owner = User.find_by(account_id: account_id, account_role: 1)
                    account_email = account_owner.email
                    language = account_owner.sitelanguage
                
                    admin_subject = "€#{amount} from #{account_email}"
                    admin_message = (
                         "Account ID: #{account_id}" + "<br />" +
                         "Customer email: #{account_email}" + "<br /><br />" +
                         "Event ID: #{stripe_event_id}" + "<br />" + 
                         "Object ID: #{stripe_object_id}" + "<br />" + 
                         "Customer ID: #{stripe_customer_id}" + "<br />" +
                         "Type: #{stripe_event_type}" + "<br />" + 
                         "Amount: € #{amount}"
                        ).html_safe

                    @payment = Payment.find_by(external_payment_id: stripe_object_id)
                    @payment.update(external_payment_status: stripe_object_status)
                    PaymentMailer.payment_success(account_id, account_email, language, amount).deliver_now
                    PaymentMailer.payment_admin_message(admin_subject, admin_message).deliver_now
            end
        end
    end
end