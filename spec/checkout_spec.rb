require 'spec_helper'

RSpec.describe Checkout do
  let(:repository) { ProductsRepository.new }
  let(:checkout) { Checkout.new(repository) }

  before do
    repository.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
    repository.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
    repository.add_product(Product.new(code: 'CF1', name: 'Coffee', price: 11.23))
  end

  describe '#scan' do
    it 'adds a product to the basket by scanning its code' do
      checkout.scan('GR1')

      expect(checkout.basket).to include(repository.find_product_by_code('GR1'))
    end

    it 'raises an error when scanning an invalid product code' do
      expect { checkout.scan('INVALID') }.to raise_error("Product with code 'INVALID' not found.")
    end
  end

  describe '#total' do
    context 'with an empty basket' do
      it 'returns 0.00' do
        expect(checkout.total).to eq(Money.from_amount(0.00))
      end
    end

    context 'with one product in the basket' do
      it 'returns the price of that product' do
        checkout.scan('GR1')

        expect(checkout.total).to eq(Money.from_amount(3.11))
      end
    end

    context 'with multiple products in the basket' do
      it 'returns the sum of the prices of all scanned products' do
        checkout.scan('GR1')
        checkout.scan('SR1')
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('CF1')
        
        expect(checkout.total).to eq(Money.from_amount(25.56))
      end
    end
  end
end
