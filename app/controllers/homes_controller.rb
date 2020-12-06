class HomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  
    puts '****************'
    puts @products.inspect
    puts '****************'
  end

  def show
  end

  def destroy
  end

  def create
    puts '*******Hello*********'
    puts params.inspect
    puts '****************'
  end

  def edit
  end

  def update
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:order).permit(product_id: [])
  end
end
