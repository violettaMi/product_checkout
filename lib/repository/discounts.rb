# frozen_string_literal: true

module Repository
  class Discounts
    def initialize
      @discounts = {}
    end

    def apply(product_code, strategy_class, **params)
      discounts[product_code] ||= []
      discounts[product_code] << strategy_class.new(**params)
    end

    def applicable_discounts(product_code)
      discounts[product_code] || []
    end

    private

    attr_reader :discounts
  end
end
