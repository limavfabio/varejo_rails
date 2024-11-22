require "test_helper"

class SalesPaymentMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_payment_method = sales_payment_methods(:one)
  end

  test "should get index" do
    get sales_payment_methods_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_payment_method_url
    assert_response :success
  end

  test "should create sales_payment_method" do
    assert_difference("SalesPaymentMethod.count") do
      post sales_payment_methods_url, params: { sales_payment_method: { amount: @sales_payment_method.amount, payment_method_id: @sales_payment_method.payment_method_id, sale_id: @sales_payment_method.sale_id } }
    end

    assert_redirected_to sales_payment_method_url(SalesPaymentMethod.last)
  end

  test "should show sales_payment_method" do
    get sales_payment_method_url(@sales_payment_method)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_payment_method_url(@sales_payment_method)
    assert_response :success
  end

  test "should update sales_payment_method" do
    patch sales_payment_method_url(@sales_payment_method), params: { sales_payment_method: { amount: @sales_payment_method.amount, payment_method_id: @sales_payment_method.payment_method_id, sale_id: @sales_payment_method.sale_id } }
    assert_redirected_to sales_payment_method_url(@sales_payment_method)
  end

  test "should destroy sales_payment_method" do
    assert_difference("SalesPaymentMethod.count", -1) do
      delete sales_payment_method_url(@sales_payment_method)
    end

    assert_redirected_to sales_payment_methods_url
  end
end
