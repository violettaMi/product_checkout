# frozen_string_literal: true

require 'money'
require 'active_support/all'

class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = convert_to_money(price)
  end

  def valid?
    code_valid? && name_valid? && price_valid?
  end

  def valid!
    validate_code!
    validate_name!
    validate_price!
  end

  private

  def convert_to_money(amount)
    raise 'Price must be a numeric value' unless amount.is_a?(Numeric)

    Money.from_amount(amount)
  end

  def code_valid?
    code.present? && code.strip.present?
  end

  def name_valid?
    name.present? && name.strip.present?
  end

  def price_valid?
    price.is_a?(Money) && price > Money.zero
  end

  def validate_code!
    raise "Product code can't be blank" unless code_valid?
  end

  def validate_name!
    raise "Product name can't be blank" unless name_valid?
  end

  def validate_price!
    raise 'Product price must be a Money object' unless price.is_a?(Money)
    raise 'Product price must be greater than zero' unless price_valid?
  end
end
