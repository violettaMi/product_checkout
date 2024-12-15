require 'spec_helper'

RSpec.describe DiscountStrategies::BulkPrice do
  let(:repository) { Repositories::Products.new }

  before do
    repository.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
  end

  let(:product) { repository.find_product_by_code('SR1') }

  it 'returns 0.00 when quantity is less than required' do
    discount = DiscountStrategies::BulkPrice.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 2)
    
    expect(discount.apply(line_item)).to eq(Money.from_amount(0.00))
  end

  it 'applies discount when quantity meets or exceeds required quantity' do
    discount = DiscountStrategies::BulkPrice.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 3)

    expect(discount.apply(line_item)).to eq(Money.from_amount(1.50))
  end

  it 'applies larger discount for more items' do
    discount = DiscountStrategies::BulkPrice.new(required_quantity: 3, new_price: 4.50)
    line_item = LineItem.new(product, 5)

    expect(discount.apply(line_item)).to eq(Money.from_amount(2.50))
  end
end
