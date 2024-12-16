# Product Checkout

This app scans products, calculates totals, and applies various discount strategies for specific products. It's designed to be maintainable, extensible, and follows SOLID principles, allowing users to introduce new products, discounts, and pricing rules.

## Architecture

- **Products and Pricing**: Each `Product` has a code, name, and price.
- **Line Items**: The `Checkout` groups scanned products into `LineItem`s, making it easier to apply discounts based on quantity.
- **Repositories**:
  - `Repository::Products` stores and validates products.
  - `Repository::Discounts` associates specific products with discount strategies.
- **Discount Strategies**: Placed under `DiscountStrategy` namespace, each implements a common interface:
  - **BuyOneGetOneFree**: Configurable by required and free quantities.
  - **BulkPrice**: If you buy a certain quantity, the price for each item changes to a specified bulk price.
  - **FractionalPrice**: If you buy a certain quantity, all items' prices for that product are multiplied by a fraction (e.g., 2/3).

The `Checkout` class:
- Scans product codes.
- Converts scanned items into `LineItem`s.
- Applies all applicable discount strategies for each product line.
- Calculates the final total (subtotal minus all discounts).

This modular design makes it simple to add new strategies without modifying existing code (O in SOLID).

## Installation

1. **Ensure Ruby and Bundler are Installed**:
   - Ruby version 3.0 or higher.
   - Bundler gem.

2. **Clone the Repository**:
   ```bash
   git clone git@github.com:violettaMi/product_checkout.git
   cd product_checkout
   ```

3. **Install Dependencies**:
   ```bash
   bundle install
   ```

## Running Tests

Execute the test suite to verify the functionality of products, discounts, and checkout logic.

```bash
bundle exec rspec
```

All tests should be green.

## Running the Demo

An example script `app.rb` is provided to demonstrate the system in action.

```bash
ruby app.rb
```

### Example Scenarios

1. **Basket: GR1, GR1**
   - **Discount Applied**: Buy One Get One Free on `GR1`.
   - **Total**: £3.11

2. **Basket: SR1, SR1, SR1**
   - **Discount Applied**: Bulk Price Discount on `SR1` (3 or more for £4.50 each).
   - **Total**: £13.50

3. **Basket: GR1, SR1, GR1, GR1, CF1**
   - **Discounts Applied**:
     - Buy One Get One Free on `GR1`.
     - Bulk Price Discount on `SR1`.
   - **Total**: £27.84

4. **Basket: CF1, CF1, CF1**
   - **Discount Applied**: Fractional Price Discount on `CF1` (3 or more at two-thirds price).
   - **Total**: £22.46

### Customizing the Demo

You can modify `app.rb` to test different baskets, add more products, or apply different discount strategies. This flexibility allows you to experiment with various scenarios and understand how discounts impact the total price.

## Summary

The Product Checkout System is a robust and flexible solution for managing product scanning and discount application. Its adherence to SOLID principles ensures that it remains maintainable and scalable, allowing for easy integration of new features and discount strategies in the future.

Feel free to explore the codebase, run the demo, and extend the system to fit your specific needs!
