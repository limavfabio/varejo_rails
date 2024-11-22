require "application_system_test_case"

class SalesPaymentMethodsTest < ApplicationSystemTestCase
  setup do
    @sales_payment_method = sales_payment_methods(:one)
  end

  test "visiting the index" do
    visit sales_payment_methods_url
    assert_selector "h1", text: "Sales payment methods"
  end

  test "should create sales payment method" do
    visit sales_payment_methods_url
    click_on "New sales payment method"

    fill_in "Amount", with: @sales_payment_method.amount
    fill_in "Payment method", with: @sales_payment_method.payment_method_id
    fill_in "Sale", with: @sales_payment_method.sale_id
    click_on "Create Sales payment method"

    assert_text "Sales payment method was successfully created"
    click_on "Back"
  end

  test "should update Sales payment method" do
    visit sales_payment_method_url(@sales_payment_method)
    click_on "Edit this sales payment method", match: :first

    fill_in "Amount", with: @sales_payment_method.amount
    fill_in "Payment method", with: @sales_payment_method.payment_method_id
    fill_in "Sale", with: @sales_payment_method.sale_id
    click_on "Update Sales payment method"

    assert_text "Sales payment method was successfully updated"
    click_on "Back"
  end

  test "should destroy Sales payment method" do
    visit sales_payment_method_url(@sales_payment_method)
    click_on "Destroy this sales payment method", match: :first

    assert_text "Sales payment method was successfully destroyed"
  end
end
