require 'json'

class HomesController < ApplicationController
  Stripe.api_key = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc'

  # before_action :authenticate_user!
  before_action :set_product, :set_all_product, only: %i[edit update destroy]
  before_action :summary, only: %i[show edit update destroy]

  def index
    @products = Product.cart(get_zenbil)
  end

  def show
    @zenbil = Order.cart(get_zenbil)
  end

  def destroy
    unless @all_product_orders.empty?
      @whole_product = false
      if params[:all].eql?('1')
        @whole_product = true
        Order.where(product_id: @product.id, zenbil: get_zenbil).destroy_all
        @all_product_orders = @all_product_orders.map do |order|
          order unless order.product_id.eql?(@product.id)
        end
      else
        @deleted_order = Order.destroy(@all_product_orders[0].id)
        @all_product_orders = @all_product_orders.drop(1)
      end
    end

    respond_to do |format|
      format.js { render 'destroy', layout: false }
    end
  end

  def create
    product_params.each do |order, _i|
      set_zenbil
      @order = current_user.orders.build(product_id: order.to_i, zenbil: get_zenbil)
      if @order.save
        # format.json { render :show, status: :created, location: @order }
      else
        puts 'error'
      end
    end

    redirect_to root_url and return

    # redirect_to home_url(:id => get_zenbil) and return
    # format.html { redirect_to home_url, notice: 'Event was successfully destroyed.' }
  end

  def edit; end

  def update
    @order = Order.new(product_id: @product.id, user_id: get_stranger_id, zenbil: get_zenbil)
    if @order.save
      flash[:success] = 'Product Added'
    else
      flash[:error] = 'Something went wrong'
    end

    respond_to do |format|
      format.js { render 'update', layout: false }
    end
  end

  def checkout
    session = Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 line_items: [{
                                                   price_data: {
                                                     currency: 'usd',
                                                     product_data: {
                                                       name: 'T-shirt'
                                                     },
                                                     unit_amount: 2000
                                                   },
                                                   quantity: 1
                                                 }],
                                                 mode: 'payment',
                                                 success_url: "https://yoursite.com/success.html",
                                                 cancel_url: 'https://example.com/cancel',
                                               })

    { id: session.id }.to_json
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_all_product
    @all_product_orders = Order.where(product_id: params[:id], user_id: get_stranger_id, zenbil: get_zenbil)
  end

  def product_param
    params.require(:id).to_i
  end

  def summary
    @order_summary = { estimated_total: 0, total_product: 0 }
    @zenbil = Order.cart(get_zenbil)

    if @zenbil && !@zenbil.empty?
      @order_summary[:estimated_total] = @zenbil.map { |order| order.price * order.pieces }.reduce(:+)
      @order_summary[:total_product] = @zenbil.length
    end

    @order_summary
  end
end
