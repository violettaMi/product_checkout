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

    context 'with fractional price discount on CF1' do
      before do
        discounts.apply('CF1', FractionalPriceDiscount, required_quantity: 3, fraction: 2.0/3.0)
      end

      it 'returns normal price if less than required quantity' do
        checkout.scan('CF1')
        checkout.scan('CF1')

        expect(checkout.total).to eq(Money.from_amount(22.46))
      end

      it 'applies fractional discount when hitting the required quantity' do
        checkout.scan('CF1')
        checkout.scan('CF1')
        checkout.scan('CF1')
        
        original = Money.from_amount(33.69)
        discounted = original * (2.0/3.0)

        expect(checkout.total).to eq(discounted)
      end

      it 'applies fractional discount for more than required quantity' do
        checkout.scan('CF1')
        checkout.scan('CF1')
        checkout.scan('CF1')
        checkout.scan('CF1')

        original = Money.from_amount(44.92)
        discounted = original * (2.0/3.0)

        expect(checkout.total).to eq(discounted)
      end
    end

    context 'with multiple discounts applied to different products' do
      before do
        discounts.apply('GR1', BuyOneGetOneFreeDiscount, required_quantity: 1, free_quantity: 1)
        discounts.apply('SR1', BulkPriceDiscount, required_quantity: 3, new_price: 4.50)
        discounts.apply('CF1', FractionalPriceDiscount, required_quantity: 3, fraction: 2.0/3.0)
      end

      it 'applies one free discount to GR1' do
        checkout.scan('GR1')
        checkout.scan('GR1')

        expect(checkout.total).to eq(Money.from_amount(3.11))
      end

      it 'applies bulk price discount to SR1' do
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')

        expect(checkout.total).to eq(Money.from_amount(13.50))
      end

      it 'applies fractional price discount to CF1' do
        checkout.scan('CF1')
        checkout.scan('CF1')
        checkout.scan('CF1')

        original_subtotal = Money.from_amount(33.69)
        discounted_subtotal = original_subtotal * (2.0/3.0)
        discount_amount = original_subtotal - discounted_subtotal
        expected_total = original_subtotal - discount_amount

        expect(checkout.total).to eq(discounted_subtotal)
      end

      it 'applies all discounts to their respective products in a mixed basket' do
        checkout.scan('GR1')
        checkout.scan('GR1')
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('SR1')
        checkout.scan('CF1')
        checkout.scan('CF1')
        checkout.scan('CF1')

        original_cf_subtotal = Money.from_amount(33.69)
        cf_discounted_subtotal = original_cf_subtotal * (2.0/3.0)
        cf_total = cf_discounted_subtotal
        gr_total = Money.from_amount(3.11)
        sr_total = Money.from_amount(13.50)

        expected_total = gr_total + sr_total + cf_total
        expect(checkout.total).to eq(expected_total)
      end
    end
  end
end
