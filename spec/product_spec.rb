require 'spec_helper'
require_relative '../lib/product'

RSpec.describe Product do
  describe '#valid?' do
    context 'with valid attributes' do
      it 'returns true' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)
        expect(product.valid?).to eq(true)
      end
    end

    context 'without a code' do
      it 'returns false when code is nil' do
        product = Product.new(code: nil, name: 'Green Tea', price: 3.11)
        expect(product.valid?).to eq(false)
      end

      it 'returns false when code is empty' do
        product = Product.new(code: '   ', name: 'Green Tea', price: 3.11)
        expect(product.valid?).to eq(false)
      end
    end

    context 'without a name' do
      it 'returns false when name is nil' do
        product = Product.new(code: 'GR1', name: nil, price: 3.11)
        expect(product.valid?).to eq(false)
      end

      it 'returns false when name is empty' do
        product = Product.new(code: 'GR1', name: '   ', price: 3.11)
        expect(product.valid?).to eq(false)
      end
    end

    context 'with non-positive price' do
      it 'returns false when price is zero' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: 0.0)
        expect(product.valid?).to eq(false)
      end

      it 'returns false when price is negative' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: -1.00)
        expect(product.valid?).to eq(false)
      end
    end
  end

  describe '#valid!' do
    context 'with valid attributes' do
      it 'does not raise an error' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)
        expect { product.valid! }.not_to raise_error
      end
    end

    context 'without a code' do
      it 'raises an error when code is nil' do
        product = Product.new(code: nil, name: 'Green Tea', price: 3.11)
        expect { product.valid! }.to raise_error("Product code can't be blank")
      end

      it 'raises an error when code is empty' do
        product = Product.new(code: '   ', name: 'Green Tea', price: 3.11)
        expect { product.valid! }.to raise_error("Product code can't be blank")
      end
    end

    context 'without a name' do
      it 'raises an error when name is nil' do
        product = Product.new(code: 'GR1', name: nil, price: 3.11)
        expect { product.valid! }.to raise_error("Product name can't be blank")
      end

      it 'raises an error when name is empty' do
        product = Product.new(code: 'GR1', name: '   ', price: 3.11)
        expect { product.valid! }.to raise_error("Product name can't be blank")
      end
    end

    context 'with non-positive price' do
      it 'raises an error when price is zero' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: 0.0)
        expect { product.valid! }.to raise_error("Product price must be greater than zero")
      end

      it 'raises an error when price is negative' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: -1.00)
        expect { product.valid! }.to raise_error("Product price must be greater than zero")
      end
    end
  end
end
