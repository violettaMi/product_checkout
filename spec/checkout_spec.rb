require 'spec_helper'

RSpec.describe Checkout do
  let(:repository) { ProductsRepository.new }
  let(:discounts) { DiscountsRepository.new }
  let(:checkout) { Checkout.new(repository, discounts) }

  before do
    repository.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
    repository.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
    repository.add_product(Product.new(code: 'CF1', name: 'Coffee', price: 11.23))
  end

  describe '#scan' do
    it 'adds a product to the basket by scanning its code' do
      checkout.scan('GR1')
      product = repository.find_product_by_code('GR1')

      expect(checkout.basket).to include('GR1')
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
      it 'returns the price of that product without discount' do
        checkout.scan('GR1')

        expect(checkout.total).to eq(Money.from_amount(3.11))
      end
    end

    context 'with discounts applied to a product' do
      before do
        discounts.apply('GR1', BuyOneGetOneFreeDiscount, required_quantity: 1, free_quantity: 1)
      end

      it 'applies the Buy One Get One Free discount for two GR1' do
        checkout.scan('GR1')
        checkout.scan('GR1')

        expect(checkout.total).to eq(Money.from_amount(3.11))
      end

      it 'applies the discount correctly for multiple GR1 items' do
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('GR1')

        expect(checkout.total).to eq(Money.from_amount(6.22))
      end

      it 'applies discounts only to eligible products' do
        checkout.scan('GR1')
        checkout.scan('SR1')
        checkout.scan('GR1')
        checkout.scan('CF1')

        expect(checkout.total).to eq(Money.from_amount(19.34))
      end
    end
  end
end
