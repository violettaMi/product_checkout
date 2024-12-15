require 'spec_helper'

RSpec.describe DiscountStrategies::BuyOneGetOneFree do
  let(:repository) { Repositories::Products.new }

  before do
    repository.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
  end

  describe '#apply' do
    let(:product) { repository.find_product_by_code('GR1') }

    context 'with no discount scenario' do
      it 'returns 0.00 when only one product is present' do
        discount = DiscountStrategies::BuyOneGetOneFree.new(required_quantity: 1, free_quantity: 1)
        line_item = LineItem.new(product, 1)
        expect(discount.apply(line_item)).to eq(Money.from_amount(0.00))
      end
    end

    context 'with eligible scenario' do
      it 'applies discount for two products' do
        discount = DiscountStrategies::BuyOneGetOneFree.new(required_quantity: 1, free_quantity: 1)
        line_item = LineItem.new(product, 2)
        expect(discount.apply(line_item)).to eq(Money.from_amount(3.11))
      end

      it 'applies discount for multiple products' do
        discount = DiscountStrategies::BuyOneGetOneFree.new(required_quantity: 1, free_quantity: 1)
        line_item = LineItem.new(product, 4)
        expect(discount.apply(line_item)).to eq(Money.from_amount(6.22))
      end
    end
  end
end
