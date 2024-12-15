# lib/buy_one_get_one_free_discount.rb
require_relative 'discount_strategy'

class BuyOneGetOneFreeDiscount < DiscountStrategy
  def initialize(required_quantity:, free_quantity:)
    @required_quantity = required_quantity
    @free_quantity = free_quantity
  end

  def apply(line_item)
    total_free_sets = line_item.quantity / (@required_quantity + @free_quantity)
    free_items = total_free_sets * @free_quantity
    line_item.product.price * free_items
  end

  private

  attr_reader :required_quantity, :free_quantity
end
