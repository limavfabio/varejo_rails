require "application_system_test_case"

class SalesTest < ApplicationSystemTestCase
  setup do
    @fiscal_document = sales(:one)
  end

  test "visiting the index" do
    visit sales_url
    assert_selector "h1", text: "Sales"
  end

  test "should create sale" do
    visit sales_url
    click_on "New sale"

    fill_in "Customer", with: @fiscal_document.customer_id
    fill_in "Total value", with: @fiscal_document.total_price
    click_on "Create Sale"

    assert_text "Sale was successfully created"
    click_on "Back"
  end

  test "should update Sale" do
    visit sale_url(@fiscal_document)
    click_on "Edit this sale", match: :first

    fill_in "Customer", with: @fiscal_document.customer_id
    fill_in "Total value", with: @fiscal_document.total_price
    click_on "Update Sale"

    assert_text "Sale was successfully updated"
    click_on "Back"
  end

  test "should destroy Sale" do
    visit sale_url(@fiscal_document)
    click_on "Destroy this sale", match: :first

    assert_text "Sale was successfully destroyed"
  end
end
