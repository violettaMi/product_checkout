class Checkout
  attr_reader :basket

  def initialize(products_repository, discounts_repository)
    @products_repository = products_repository
    @discounts_repository = discounts_repository
    @basket = []
  end

  def scan(code)
    product = @products_repository.find_product_by_code(code)
    @basket << product.code
  end

  def total
    line_items = build_line_items
    subtotal = line_items.reduce(Money.from_amount(0.00)) { |sum, li| sum + li.subtotal }
    discount = calculate_total_discount(line_items)
    subtotal - discount
  end

  private

  attr_reader :products_repository, :discounts_repository

  def build_line_items
    grouped = @basket.group_by { |code| code }
    grouped.map do |code, codes|
      product = products_repository.find_product_by_code(code)
      LineItem.new(product, codes.size)
    end
  end

  def calculate_total_discount(line_items)
    line_items.reduce(Money.from_amount(0.00)) do |sum, line_item|
      discounts_repository.applicable_discounts(line_item.product.code).reduce(sum) do |d_sum, strategy|
        d_sum + strategy.apply(line_item)
      end
    end
  end
end
