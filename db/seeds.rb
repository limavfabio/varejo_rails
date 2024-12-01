# db/seeds.rb
require 'faker'

# Create Companies
10.times do
  Company.create!(
    name: Faker::Company.name
  )
end

User.create!(
  name: 'Admin',
  email: "admin@admin.com",
  password: 'password',
  verified: true,
  role: 2,
  company: Company.first,
)

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
  payment_methods = [
    "Credit Card",
    "Debit Card",
    "Cash",
    "PIX"
  ]
  payment_methods.each do |payment_method|
    PaymentMethod.create!(name: payment_method, company: company)
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
      company: company
    )

    # Create Sale Products
    2.times do
      product = Product.where(company: company).sample
      SaleProduct.create!(
        sale: sale,
        product: product,
        quantity: rand(1..5),
      )
    end

    # Create Sale Payment Methods
    1.times do
      payment_method = PaymentMethod.where(company: company).sample
      SalePayment.create!(
        sale: sale,
        payment_method: payment_method,
        amount: sale.sale_products.sum
        { |sale_product| sale_product.product.retail_price * sale_product.quantity }
      )
    end
  end
end

# Create Sessions
# users = User.all
# users.each do |user|
#   3.times do
#     Session.create!(
#       user: user,
#       user_agent: Faker::Internet.user_agent,
#       ip_address: Faker::Internet.ip_v4_address
#     )
#   end
# end
