class SalesProductsController < ApplicationController
  before_action :set_sales_product, only: %i[ show edit update destroy ]

  # GET /sales_products or /sales_products.json
  def index
    @sales_products = SalesProduct.all
  end

  # GET /sales_products/1 or /sales_products/1.json
  def show
  end

  # GET /sales_products/new
  def new
    @sales_product = SalesProduct.new
  end

  # GET /sales_products/1/edit
  def edit
  end

  # POST /sales_products or /sales_products.json
  def create
    @sales_product = SalesProduct.new(sales_product_params)

    respond_to do |format|
      if @sales_product.save
        format.html { redirect_to @sales_product, notice: "Sales product was successfully created." }
        format.json { render :show, status: :created, location: @sales_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_products/1 or /sales_products/1.json
  def update
    respond_to do |format|
      if @sales_product.update(sales_product_params)
        format.html { redirect_to @sales_product, notice: "Sales product was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_products/1 or /sales_products/1.json
  def destroy
    @sales_product.destroy!

    respond_to do |format|
      format.html { redirect_to sales_products_path, status: :see_other, notice: "Sales product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_product
      @sales_product = SalesProduct.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sales_product_params
      params.expect(sales_product: [ :sale_id, :product_id, :quantity, :total_price ])
    end
end
