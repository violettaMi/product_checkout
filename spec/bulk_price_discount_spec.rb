require 'spec_helper'

RSpec.describe BulkPriceDiscount do
  let(:repository) { ProductsRepository.new }

  before do
    repository.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
  end

  let(:product) { repository.find_product_by_code('SR1') }

  it 'returns 0.00 when quantity is less than required' do
    discount = BulkPriceDiscount.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 2)
    expect(discount.apply(line_item)).to eq(Money.from_amount(0.00))
  end

  it 'applies discount when quantity meets or exceeds required quantity' do
    discount = BulkPriceDiscount.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 3)
    # Original: 3 * 5.00 = 15.00
    # Discounted: 3 * 4.50 = 13.50
    # Discount: 15.00 - 13.50 = 1.50
    expect(discount.apply(line_item)).to eq(Money.from_amount(1.50))
  end

  it 'applies larger discount for more items' do
    discount = BulkPriceDiscount.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 5)
    # Original: 5 * 5.00 = 25.00
    # Discounted: 5 * 4.50 = 22.50
    # Discount: 25.00 - 22.50 = 2.50
    expect(discount.apply(line_item)).to eq(Money.from_amount(2.50))
  end
end
