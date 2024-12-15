# spec/line_item_spec.rb
require 'spec_helper'

RSpec.describe LineItem do
  let(:repository) { ProductsRepository.new }

  before do
    repository.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
  end

  describe '#subtotal' do
    it 'calculates the subtotal for a given quantity' do
      product = repository.find_product_by_code('GR1')
      line_item = LineItem.new(product, 3)
      expect(line_item.subtotal).to eq(Money.from_amount(9.33))
    end
  end
end
