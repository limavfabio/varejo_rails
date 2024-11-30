# db/seeds.rb
require 'faker'

# Create Companies
10.times do
  Company.create!(
    name: Faker::Company.name
  )
end

# Create Users
companies = Company.all
5.times do
  companies.each do |company|
    User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      password: 'password', # Make sure to use a secure password in production
      verified: Faker::Boolean.boolean,
      role: rand(0..2), # Assuming you have roles defined as integers
      company: company
    )
  end
end

# Create Customers
companies.each do |company|
  5.times do
    Customer.create!(
      name: Faker::Name.name,
      address: Faker::Address.full_address,
      company: company
    )
  end
end

# Create Payment Methods
companies.each do |company|
  3.times do
    PaymentMethod.create!(
      name: Faker::Finance.credit_card_type,
      company: company
    )
  end
end

# Create Products
companies.each do |company|
  5.times do
    Product.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Commerce.department(max: 1),
      retail_price: Faker::Commerce.price,
      company: company
    )
  end
end

# Create Sales
companies.each do |company|
  5.times do
    customer = Customer.where(company: company).sample
    sale = Sale.create!(
      customer: customer,
      total_price: Faker::Commerce.price,
      company: company
    )

    # Create Sale Products
    2.times do
      product = Product.where(company: company).sample
      SaleProduct.create!(
        sale: sale,
        product: product,
        quantity: rand(1..5),
        total_price: product.retail_price * rand(1..5)
      )
    end

    # Create Sale Payment Methods
    1.times do
      payment_method = PaymentMethod.where(company: company).sample
      SalePaymentMethod.create!(
        sale: sale,
        payment_method: payment_method,
        amount: sale.total_price
      )
    end
  end
end

# Create Sessions
users = User.all
users.each do |user|
  3.times do
    Session.create!(
      user: user,
      user_agent: Faker::Internet.user_agent,
      ip_address: Faker::Internet.ip_v4_address
    )
  end
end

puts "Database seeded with sample data!"
