require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fiscal_document = sales(:one)
  end

  test "should get index" do
    get sales_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_url
    assert_response :success
  end

  test "should create sale" do
    assert_difference("Sale.count") do
      post sales_url, params: { sale: { customer_id: @fiscal_document.customer_id, total_value: @fiscal_document.total_price } }
    end

    assert_redirected_to sale_url(Sale.last)
  end

  test "should show sale" do
    get sale_url(@fiscal_document)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_url(@fiscal_document)
    assert_response :success
  end

  test "should update sale" do
    patch sale_url(@fiscal_document), params: { sale: { customer_id: @fiscal_document.customer_id, total_value: @fiscal_document.total_price } }
    assert_redirected_to sale_url(@fiscal_document)
  end

  test "should destroy sale" do
    assert_difference("Sale.count", -1) do
      delete sale_url(@fiscal_document)
    end

    assert_redirected_to sales_url
  end
end
