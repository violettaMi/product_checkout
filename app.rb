# frozen_string_literal: true

require 'money'
require 'active_support/all'

require_relative 'lib/product'
require_relative 'lib/repository/products'
require_relative 'lib/repository/discounts'
require_relative 'lib/line_item'
require_relative 'lib/checkout'
require_relative 'lib/discount'
require_relative 'lib/discount_strategy/buy_one_get_one_free'
require_relative 'lib/discount_strategy/bulk_price'
require_relative 'lib/discount_strategy/fractional_price'

Money.default_currency = 'GBP'

products = Repository::Products.new
discounts = Repository::Discounts.new

products.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
products.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
products.add_product(Product.new(code: 'CF1', name: 'Coffee', price: 11.23))

# Apply discounts
discounts.apply('GR1', DiscountStrategy::BuyOneGetOneFree, required_quantity: 1, free_quantity: 1)
discounts.apply('SR1', DiscountStrategy::BulkPrice, required_quantity: 3, new_price: 4.50)
discounts.apply('CF1', DiscountStrategy::FractionalPrice, required_quantity: 3, fraction: 2.0 / 3.0)

# Basket 1: GR1,SR1,GR1,GR1,CF1
checkout = Checkout.new(products, discounts)
checkout.scan('GR1')
checkout.scan('SR1')
checkout.scan('GR1')
checkout.scan('GR1')
checkout.scan('CF1')
puts "Basket: GR1,SR1,GR1,GR1,CF1 -> Total: #{checkout.total.format}"

# Basket 2: GR1, GR1
checkout = Checkout.new(products, discounts)
checkout.scan('GR1')
checkout.scan('GR1')
puts "Basket: GR1,GR1 -> Total: #{checkout.total.format}"

# Basket 3: SR1,SR1,GR1,SR1
checkout = Checkout.new(products, discounts)
checkout.scan('SR1')
checkout.scan('SR1')
checkout.scan('GR1')
checkout.scan('SR1')
puts "Basket: SR1,SR1,GR1,SR1 -> Total: #{checkout.total.format}"

# Basket 4: GR1,CF1,SR1,CF1,CF1
checkout = Checkout.new(products, discounts)
checkout.scan('GR1')
checkout.scan('CF1')
checkout.scan('SR1')
checkout.scan('CF1')
checkout.scan('CF1')
puts "Basket: GR1,CF1,SR1,CF1,CF1 -> Total: #{checkout.total.format}"
