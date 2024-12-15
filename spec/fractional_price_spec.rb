require 'spec_helper'

RSpec.describe DiscountStrategies::FractionalPrice do
  let(:repository) { ProductsRepository.new }

  before do
    repository.add_product(Product.new(code: 'CF1', name: 'Coffee', price: 11.23))
  end

  let(:product) { repository.find_product_by_code('CF1') }

  it 'returns 0.00 when quantity is less than required' do
    discount = DiscountStrategies::FractionalPrice.new(required_quantity: 3, fraction: 2.0/3.0)
    line_item = LineItem.new(product, 2)

    expect(discount.apply(line_item)).to eq(Money.from_amount(0.00))
  end

  it 'applies fractional discount when hitting the required quantity' do
    discount = DiscountStrategies::FractionalPrice.new(required_quantity: 3, fraction: 2.0/3.0)
    line_item = LineItem.new(product, 3)
    original_subtotal = Money.from_amount(33.69)
    discounted_subtotal = original_subtotal * (2.0/3.0)
    discount_amount = original_subtotal - discounted_subtotal

    expect(discount.apply(line_item)).to eq(discount_amount)
  end

  it 'applies fractional discount for more than required quantity' do
    discount = DiscountStrategies::FractionalPrice.new(required_quantity: 3, fraction: 2.0/3.0)
    line_item = LineItem.new(product, 5)
    original_subtotal = Money.from_amount(56.15)
    discounted_subtotal = original_subtotal * (2.0/3.0)
    discount_amount = original_subtotal - discounted_subtotal
    
    expect(discount.apply(line_item)).to eq(discount_amount)
  end
end
