class Product < ApplicationRecord
  has_many_attached :files
  has_many :orders

  scope :cart, lambda { |zenb|
    Product.joins("left outer join orders on products.id = product_id AND zenbil ='#{zenb}'").group('products.id')
           .select('products.*, count(orders.product_id) as pieces')
  }
end
 
