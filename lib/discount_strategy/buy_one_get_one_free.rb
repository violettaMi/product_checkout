# frozen_string_literal: true

require_relative '../discount'

module DiscountStrategy
  class BuyOneGetOneFree < Discount
    # rubocop:disable Lint/MissingSuper
    def initialize(required_quantity:, free_quantity:)
      @required_quantity = required_quantity
      @free_quantity = free_quantity
    end
    # rubocop:enable Lint/MissingSuper

    def apply(line_item)
      total_free_sets = line_item.quantity / (required_quantity + free_quantity)
      free_items = total_free_sets * free_quantity
      line_item.product.price * free_items
    end

    private

    attr_reader :required_quantity, :free_quantity
  end
end
