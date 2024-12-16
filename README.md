# Product Checkout System

This system is designed to scan products, calculate totals, and apply various discount strategies to specific products.
It is structured to be maintainable, extensible, and follows SOLID principles, allowing users to easily introduce new products, discounts, and pricing rules.

## Key Components

**Product**: Represents an individual item with a code, name, and price.
**LineItem**: Groups identical products with a quantity, simplifying discount calculations.
**Repositories** (under `Repository` namespace):
  - **Products**: Manages product storage and retrieval.
  - **Discounts**: Associates products with their discount strategies.
 **Checkout**: Scans product codes, builds line items, and calculates the total price by applying discounts.
**Discount Strategies** (under `DiscountStrategy` namespace):
  - **BuyOneGetOneFree**: Buy X items, get Y items free (e.g., buy one get two).
  - **BulkPrice**: If you buy a required quantity, the price of each item changes to a specified bulk price.
  - **FractionalPrice**: If you meet a required quantity, all item prices are reduced by a certain fraction.

## Flow

1. Add products to `Repository::Products`.
2. Register discounts per product code in `Repository::Discounts`.
3. `Checkout` scans product codes and converts them into `LineItem`s.
4. `Checkout#total` calculates the subtotal of all line items, then applies each discount strategy relevant to each product code.
5. The final total reflects all discounts applied.

## Example

```ruby
products = Repository::Products.new
discounts = Repository::Discounts.new

products.add_product(Product.new(code: 'GR1', name: 'Green Tea', price: 3.11))
products.add_product(Product.new(code: 'SR1', name: 'Strawberries', price: 5.00))
products.add_product(Product.new(code: 'CF1', name: 'Coffee', price: 11.23))

# Apply discounts to specific products
discounts.apply('GR1', DiscountStrategy::BuyOneGetOneFree, required_quantity: 1, free_quantity: 1)
discounts.apply('SR1', DiscountStrategy::BulkPrice, required_quantity: 3, new_price: 4.50)
discounts.apply('CF1', DiscountStrategy::FractionalPrice, required_quantity: 3, fraction: 2.0/3.0)

checkout = Checkout.new(products, discounts)

# Scan items
checkout.scan('GR1')
checkout.scan('GR1')
checkout.scan('SR1')
checkout.scan('SR1')
checkout.scan('SR1')
checkout.scan('CF1')
checkout.scan('CF1')
checkout.scan('CF1')

# Calculate total
checkout.total
```
This prints the total (​£39.07) with all applicable discounts.
