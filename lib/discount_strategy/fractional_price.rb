# frozen_string_literal: true

require_relative '../discount'

module DiscountStrategy
  class FractionalPrice < Discount
    # rubocop:disable Lint/MissingSuper
    def initialize(required_quantity:, fraction:)
      @required_quantity = required_quantity
      @fraction = fraction
    end
    # rubocop:enable Lint/MissingSuper

    def apply(line_item)
      return Money.from_amount(0.00) if line_item.quantity < required_quantity

      original_subtotal = line_item.subtotal
      discounted_subtotal = original_subtotal * fraction

      original_subtotal - discounted_subtotal
    end

    private

    attr_reader :required_quantity, :fraction
  end
end
