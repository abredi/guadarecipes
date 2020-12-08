class HomesController < ApplicationController
  include HomeHelper

  before_action :authenticate_user!
  before_action :set_product, only: [:edit, :update, :destory]

  def index
    @products = Product.all
  end

  def show
    @zenbil = Order.cart(get_zenbil)
    puts '****************'
    puts @zenbil.inspect
    puts '****************'
  end

  def destroy; end

  def create
    product_params.each do |order, i|
      set_zenbil
      @order = current_user.orders.build(product_id: order.to_i, zenbil: get_zenbil)
      if @order.save
        # format.json { render :show, status: :created, location: @order }
      else
        puts 'error'
      end
    end
    redirect_to home_url(:id => get_zenbil) and return
    # format.html { redirect_to home_url, notice: 'Event was successfully destroyed.' }
  end

  def edit; end

  def update; end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:orders).permit!
  end
end
