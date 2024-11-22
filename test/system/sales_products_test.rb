require "application_system_test_case"

class SalesProductsTest < ApplicationSystemTestCase
  setup do
    @sales_product = sales_products(:one)
  end

  test "visiting the index" do
    visit sales_products_url
    assert_selector "h1", text: "Sales products"
  end

  test "should create sales product" do
    visit sales_products_url
    click_on "New sales product"

    fill_in "Product", with: @sales_product.product_id
    fill_in "Quantity", with: @sales_product.quantity
    fill_in "Sale", with: @sales_product.sale_id
    fill_in "Total price", with: @sales_product.total_price
    click_on "Create Sales product"

    assert_text "Sales product was successfully created"
    click_on "Back"
  end

  test "should update Sales product" do
    visit sales_product_url(@sales_product)
    click_on "Edit this sales product", match: :first

    fill_in "Product", with: @sales_product.product_id
    fill_in "Quantity", with: @sales_product.quantity
    fill_in "Sale", with: @sales_product.sale_id
    fill_in "Total price", with: @sales_product.total_price
    click_on "Update Sales product"

    assert_text "Sales product was successfully updated"
    click_on "Back"
  end

  test "should destroy Sales product" do
    visit sales_product_url(@sales_product)
    click_on "Destroy this sales product", match: :first

    assert_text "Sales product was successfully destroyed"
  end
end
