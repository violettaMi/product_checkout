# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DiscountStrategy::BulkPrice do
  let(:repository) { Repository::Products.new }
  let(:product) { repository.find_product_by_code('SR1') }
  let(:discount) { described_class.new(required_quantity: 3, new_price: 4.50) }

  before do
    repository.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
  end

  it 'returns 0.00 when quantity is less than required' do
    line_item = LineItem.new(product, 2)

    expect(discount.apply(line_item)).to eq(Money.from_amount(0.00))
  end

  it 'applies discount when quantity meets or exceeds required quantity' do
    line_item = LineItem.new(product, 3)

    expect(discount.apply(line_item)).to eq(Money.from_amount(1.50))
  end

  it 'applies larger discount for more items' do
    line_item = LineItem.new(product, 5)

    expect(discount.apply(line_item)).to eq(Money.from_amount(2.50))
  end
end
