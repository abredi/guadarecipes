# frozen_string_literal: true

class ChargesController < ApplicationController
  Stripe.api_key = 'sk_test_51I1ul4H1O6SVZlgxcIuGjOJ6l2Twsc5WAC1pAHpJP2DHgAcsvdBdMtltwjXEOjGHBVbMPeYiBRqKhf6lkF99cpML00LX6FlAgt'

  def create
    # @customer =
    @zenbil = Order.cart(get_zenbil)
    line_items = []
    @zenbil.each do |order|
      line_items.push({
                        price_data: {
                          unit_amount: ategaga(order.price),
                          currency: 'usd',
                          product_data: {
                            name: order.name,
                            images: [order.files[0].key]
                          }
                        },
                        quantity: order.pieces
                      })
    end
    session = Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 line_items: line_items,
                                                 mode: 'payment',
                                                 success_url: "#{root_url}/charges/success",
                                                 cancel_url: "#{root_url}/charges/cancel"
                                               })

    # { id: session.id }.to_json

    respond_to do |format|
      msg = { status: 'ok', message: 'Success!', html: '<b>...</b>', id: session.id }
      format.json { render json: msg } # don't do msg.to_json
    end
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(session.customer)
    respond_to do |format|
      format.html { render :success }
    end
  end

  def cancel
    respond_to do |format|
      format.html { render :cancel }
    end
  end
end
