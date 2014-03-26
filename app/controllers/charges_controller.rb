class ChargesController < ApplicationController

  def new_charge

    token = params[:stripeToken]
    amount = params[:chargeAmount]
    centAmount = amount.to_i
    description = params[:chargeDesc]

    Stripe.api_key = STRIPE_SECRET

    # Create a customer to check address_line1, address_zip, and cvc for
    # legitimacy before charging.
    customer = Stripe::Customer.create(
      :card => token,
      :email => description,
    )

    if customer.active_card.address_line1_check == "fail"
      @error = "Address check failed."
    elsif customer.active_card.address_zip_check == "fail"
      @error = "Address check failed."
    elsif customer.active_card.cvc_check == "fail"
      @error = "CVC check failed."
    else
      charge = Stripe::Charge.create(
        :amount => centAmount, # amount in cents, again
        :currency => "usd",
        :customer => customer,
        :description => description
      )
    end

    rescue Stripe::CardError => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    rescue Stripe::InvalidRequestError => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    rescue Stripe::AuthenticationError => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    rescue Stripe::APIConnectionError => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    rescue Stripe::StripeError => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    rescue => e
      @error = e.message + '.'
      render "/pages/fail", layout: 'pages'
      return
    else 
      render "/pages/success", layout: 'pages'
    end
    

end
