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

    context 'with buy one get one free discount applied to GR1' do
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
    end

    context 'with bulk price discount applied to SR1' do
      before do
        discounts.apply('SR1', BulkPriceDiscount, required_quantity: 3, new_price: 4.50)
      end

      it 'returns normal price if less than required quantity' do
        checkout.scan('SR1')
        checkout.scan('SR1')

        expect(checkout.total).to eq(Money.from_amount(10.00))
      end

      it 'applies discounted price when hitting required quantity' do
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')

        expect(checkout.total).to eq(Money.from_amount(13.50))
      end

      it 'applies larger discount for more items' do
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')

        expect(checkout.total).to eq(Money.from_amount(18.00))
      end
    end

    context 'with both BOGO and bulk price discounts applied' do
      before do
        discounts.apply('GR1', BuyOneGetOneFreeDiscount, required_quantity: 1, free_quantity: 1)
        discounts.apply('SR1', BulkPriceDiscount, required_quantity: 3, new_price: 4.50)
      end

      it 'applies both discounts to their respective products' do
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('CF1')

        expect(checkout.total).to eq(Money.from_amount(27.84))
      end
    end
  end
end
