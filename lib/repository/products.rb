module Repository
  class Products
    def initialize
      @products = {}
    end

    def add_product(product)
      validate_product!(product)
      ensure_unique!(product)

      products[product.code] = product
    end

    def find_product_by_code(code)
      products.fetch(code) { raise_not_found_error(code) }
    end

    def all_products
      products.values
    end

    private

    attr_reader :products

    def validate_product!(product)
      product.valid!
    rescue => e
      raise "Invalid product: #{e.message}"
    end

    def ensure_unique!(product)
      if products.key?(product.code)
        raise "Product with code '#{product.code}' already exists."
      end
    end

    def raise_not_found_error(code)
      raise "Product with code '#{code}' not found."
    end
  end
end
