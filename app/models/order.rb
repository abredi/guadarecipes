class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  scope :cart, (zenb) -> { Product.joins(:orders).where(orders: {zenbil: zenb})}

end
