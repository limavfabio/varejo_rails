class SalesPaymentMethodsController < ApplicationController
  before_action :set_sales_payment_method, only: %i[ show edit update destroy ]

  # GET /sales_payment_methods or /sales_payment_methods.json
  def index
    @sales_payment_methods = SalesPaymentMethod.all
  end

  # GET /sales_payment_methods/1 or /sales_payment_methods/1.json
  def show
  end

  # GET /sales_payment_methods/new
  def new
    @sales_payment_method = SalesPaymentMethod.new
  end

  # GET /sales_payment_methods/1/edit
  def edit
  end

  # POST /sales_payment_methods or /sales_payment_methods.json
  def create
    @sales_payment_method = SalesPaymentMethod.new(sales_payment_method_params)

    respond_to do |format|
      if @sales_payment_method.save
        format.html { redirect_to @sales_payment_method, notice: "Sales payment method was successfully created." }
        format.json { render :show, status: :created, location: @sales_payment_method }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_payment_methods/1 or /sales_payment_methods/1.json
  def update
    respond_to do |format|
      if @sales_payment_method.update(sales_payment_method_params)
        format.html { redirect_to @sales_payment_method, notice: "Sales payment method was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_payment_method }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_payment_methods/1 or /sales_payment_methods/1.json
  def destroy
    @sales_payment_method.destroy!

    respond_to do |format|
      format.html { redirect_to sales_payment_methods_path, status: :see_other, notice: "Sales payment method was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_payment_method
      @sales_payment_method = SalesPaymentMethod.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sales_payment_method_params
      params.expect(sales_payment_method: [ :sale_id, :payment_method_id, :amount ])
    end
end
