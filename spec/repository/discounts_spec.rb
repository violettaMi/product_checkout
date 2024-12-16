# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Repository::Discounts do
  let(:discounts) { described_class.new }

  it 'returns an empty array if no discounts are applied' do
    expect(discounts.applicable_discounts('GR1')).to eq([])
  end

  context 'when a discount is applied' do
    before do
      discounts.apply('GR1', DiscountStrategy::BuyOneGetOneFree, required_quantity: 1, free_quantity: 1)
    end

    it 'stores the applied discount for a product' do
      applied_discounts = discounts.applicable_discounts('GR1')

      expect(applied_discounts.size).to eq(1)
    end

    it 'ensures the discount is of the correct type' do
      applied_discounts = discounts.applicable_discounts('GR1')

      expect(applied_discounts.first).to be_a(DiscountStrategy::BuyOneGetOneFree)
    end
  end
end
