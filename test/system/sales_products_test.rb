require "application_system_test_case"

class SalesProductsTest < ApplicationSystemTestCase
  setup do
    @document_item = sales_products(:one)
  end

  test "visiting the index" do
    visit sales_products_url
    assert_selector "h1", text: "Sales products"
  end

  test "should create sales product" do
    visit sales_products_url
    click_on "New sales product"

    fill_in "Product", with: @document_item.product_id
    fill_in "Quantity", with: @document_item.quantity
    fill_in "Sale", with: @document_item.sale_id
    fill_in "Total price", with: @document_item.total_price
    click_on "Create Sales product"

    assert_text "Sales product was successfully created"
    click_on "Back"
  end

  test "should update Sales product" do
    visit sales_product_url(@document_item)
    click_on "Edit this sales product", match: :first

    fill_in "Product", with: @document_item.product_id
    fill_in "Quantity", with: @document_item.quantity
    fill_in "Sale", with: @document_item.sale_id
    fill_in "Total price", with: @document_item.total_price
    click_on "Update Sales product"

    assert_text "Sales product was successfully updated"
    click_on "Back"
  end

  test "should destroy Sales product" do
    visit sales_product_url(@document_item)
    click_on "Destroy this sales product", match: :first

    assert_text "Sales product was successfully destroyed"
  end
end
