class DiscountsRepository
  def initialize
    @discounts = {}
  end

  def apply(product_code, strategy_class, **params)
    @discounts[product_code] ||= []
    @discounts[product_code] << strategy_class.new(**params)
  end

  def applicable_discounts(product_code)
    @discounts[product_code] || []
  end
end
