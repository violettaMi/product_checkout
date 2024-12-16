# frozen_string_literal: true

require_relative '../discount'

module DiscountStrategy
  class BulkPrice < Discount
    # rubocop:disable Lint/MissingSuper
    def initialize(required_quantity:, new_price:)
      @required_quantity = required_quantity
      @new_price = Money.from_amount(new_price)
    end
    # rubocop:enable Lint/MissingSuper

    def apply(line_item)
      return Money.from_amount(0.00) if line_item.quantity < required_quantity

      original_subtotal = line_item.subtotal
      discounted_subtotal = new_price * line_item.quantity

      original_subtotal - discounted_subtotal
    end

    private

    attr_reader :required_quantity, :new_price
  end
end
