# db/seeds.rb
require 'faker'

# Create Companies
10.times do
  Company.create!(
    name: Faker::Company.name
  )
end

# Create an Admin User
User.create!(
  name: 'Admin',
  email: "admin@admin.com",
  password: 'password',
  verified: true,
  role: 2, # Assuming 2 is the admin role
  company: Company.first
)

# Create Users
companies = Company.all
5.times do
  companies.each do |company|
    User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      password: 'password', # Use a secure password in production
      verified: Faker::Boolean.boolean,
      role: rand(0..2), # Assuming roles are defined as integers
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
  payment_methods = [ "Credit Card", "Debit Card", "Cash", "PIX" ]
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
      retail_price: Faker::Commerce.price(range: 50.0..100.0),
      company: company
    )
  end
end

# t.string "description"
# t.integer "operation"
# t.integer "operation_type"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# Create Fiscal Scenarios
companies.each do |company|
  FiscalScenario.create!(description: "Venda", operation: 1, operation_type: 1, company: company)
end

# Create Fiscal Documents
companies.each do |company|
  5.times do
    customer = Customer.where(company: company).sample
    fiscal_document = FiscalDocument.create!(
      company: company,
      fiscal_scenario: FiscalScenario.where(company: company).sample,
      customer: customer,
      description: Faker::Lorem.sentence,
      total_value: 0 # Will be updated after creating document items
    )

    # Create Document Items
    2.times do
      product = Product.where(company: company).sample
      DocumentItem.create!(
        fiscal_document: fiscal_document,
        product: product,
        quantity: rand(1..5)
      )
    end

    # Calculate and update total value
    total_value = fiscal_document.document_items.sum do |item|
      item.product.retail_price * item.quantity
    end
    fiscal_document.update(total_value: total_value)

    # Create Document Payments
    1.times do
      payment_method = PaymentMethod.where(company: company).sample
      DocumentPayment.create!(
        fiscal_document: fiscal_document,
        payment_method: payment_method,
        amount: total_value # Assuming full payment for simplicity
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
