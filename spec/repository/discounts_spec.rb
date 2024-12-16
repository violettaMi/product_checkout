require 'spec_helper'

RSpec.describe Repository::Discounts  do
  let(:discounts) { Repository::Discounts.new }

  it 'returns an empty array if no discounts are applied' do
    expect(discounts.applicable_discounts('GR1')).to eq([])
  end

  it 'stores and retrieves discounts for a product' do
    discounts.apply('GR1', DiscountStrategy::BuyOneGetOneFree, required_quantity: 1, free_quantity: 1)

    applied_discounts = discounts.applicable_discounts('GR1')

    expect(applied_discounts.size).to eq(1)
    expect(applied_discounts.first).to be_a(DiscountStrategy::BuyOneGetOneFree)
  end
end
