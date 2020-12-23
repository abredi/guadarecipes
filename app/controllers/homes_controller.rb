# frozen_string_literal: true

class HomesController < ApplicationController
  include HomeHelper

  # before_action :authenticate_user!
  before_action :set_product, :set_all_product, only: %i[edit update destroy]

  def index
    @products = Product.all
  end

  def show
    @zenbil = Order.cart(get_zenbil)

    # @sub_total = @zenbil.reduce()
  end

  def destroy
    unless @all_product_orders.empty?
      @whole_product = false
      if params[:all].eql?('  1')
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
end
