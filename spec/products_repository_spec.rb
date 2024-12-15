require 'spec_helper'
require_relative '../lib/product'
require_relative '../lib/products_repository'

RSpec.describe ProductsRepository do
  let(:repository) { ProductsRepository.new }

  describe '#add_product' do
    context 'when adding a new unique product' do
      it 'adds the product successfully' do
        product = Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)

        repository.add_product(product)

        expect(repository.all_products).to include(product)
      end
    end

    context 'when adding a product with a duplicate code' do
      it 'raises an error' do
        product1 = Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)
        product2 = Product.new(code: 'GR1', name: 'Green Tea Special', price: 4.50)

        repository.add_product(product1)

        expect { repository.add_product(product2) }.to raise_error("Product with code 'GR1' already exists.")
      end
    end

    context 'when adding an invalid product' do
      it 'raises an error due to invalid product' do
        invalid_product = Product.new(code: '', name: 'Invalid Product', price: -5.00)

        expect { repository.add_product(invalid_product) }.to raise_error("Invalid product: Product code can't be blank")
      end
    end
  end

  describe '#find_product_by_code' do
    context 'when the product exists in the repository' do
      it 'returns the product' do
        product = Product.new(code: 'CF1', name: 'Coffee', price: 11.23)

        repository.add_product(product)

        expect(repository.find_product_by_code('CF1')).to eq(product)
      end
    end

    context 'when the product does not exist in the repository' do
      it 'raises an error' do
        expect { repository.find_product_by_code('NON_EXISTENT') }.to raise_error("Product with code 'NON_EXISTENT' not found.")
      end
    end
  end

  describe '#all_products' do
    it 'returns all added products' do
      product1 = Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)
      product2 = Product.new(code: 'CF1', name: 'Coffee', price: 11.23)

      repository.add_product(product1)
      repository.add_product(product2)

      expect(repository.all_products).to contain_exactly(product1, product2)
    end
  end
end
