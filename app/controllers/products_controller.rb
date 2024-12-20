class ProductsController < ApplicationController
  before_action :set_product, only: %i[show stock edit update destroy]

  # GET /products or /products.json
  def index
    @q = Product.ransack(params[:q])

    @products = if request.format.json?
      Product.all
    else
      @q.result(distinct: true).order(:id).page(params[:page]).per(15)
    end
  end

  # GET /products/1 or /products/1.json
  def show
    @categories = Category.all
  end

  def stock
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.company = Current.user.company

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "O produto foi criado com sucesso." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "O produto foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "O produto foi removido com sucesso." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.expect(product: [:name, :description, :cost_price, :retail_price, :category_id])
  end
end
