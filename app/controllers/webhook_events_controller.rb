class WebhookEventsController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def create
        if !valid_signature
            render json: { message: "Signature does not match"}, status: 400
            return
        end
        
        if !WebhookEvent.find_by(source: params[:source], external_id: external_id).nil?
            render json: { message: "This event is already here"}
            return
        end
        
        event = WebhookEvent.create(webhook_params)
        case params[:source]
            when 'stripe'
                Webhooks::StripeHandler.process(event)
            when 'superfeeder'
        end
        render json: { message: "Well done, this is a: " + event.data["type"]}
    end
    
    def valid_signature
        if params[:source] == 'stripe'
        	begin
        	    if Rails.env.development?
    			    event = Stripe::Webhook.construct_event(request.raw_post, request.env['HTTP_STRIPE_SIGNATURE'], 'whsec_5IuCz8Ecp0PwQVMIXybJV9YtN0fqu1XV')
    		    elsif Rails.env.production?
    		        event = Stripe::Webhook.construct_event(request.raw_post, request.env['HTTP_STRIPE_SIGNATURE'], 'whsec_o0wkY6caBwCYRFMRtUdpxIl2cMdwRV3f')
    		    else end
    		rescue JSON::ParserError => e
    			render :json => {:status => 400, :error => "Invalid payload"} and return
    		rescue Stripe::SignatureVerificationError => e
    			render :json => {:status => 400, :error => "Invalid signature"} and return
    		end
        end
        
        true
    end
    
    def external_id
        return params[:id] if params[:source] == 'stripe'
        SecureRandom.hex
    end
    
    def webhook_params
        {
            source: params[:source],
            data: params.except(:source, :action, :controller).permit!,
            external_id: external_id
        }
    end
end