class Checkout
  attr_reader :basket

  def initialize(products_repository)
    @products_repository = products_repository
    @basket = []
  end

  def scan(code)
    product = @products_repository.find_product_by_code(code)
    @basket << product
  end

  def total
    @basket.reduce(Money.from_amount(0.00)) do |sum, product|
      sum + product.price
    end
  end

  private

  attr_reader :products_repository
end
