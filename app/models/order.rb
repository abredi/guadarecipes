# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :cart, lambda { |zenb|
    Product.joins(:orders).group('products.id').where(orders: { zenbil: zenb })
           .select('products.*, count(orders.product_id) as pieces')
  }
end

