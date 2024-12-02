class DocumentItemsController < ApplicationController
  before_action :set_document_item, only: %i[ show edit update destroy ]

  # GET /document_items or /document_items.json
  def index
    @document_items = DocumentItem.all
  end

  # GET /document_items/1 or /document_items/1.json
  def show
  end

  # GET /document_items/new
  def new
    @document_item = DocumentItem.new
  end

  # GET /document_items/1/edit
  def edit
  end

  # POST /document_items or /document_items.json
  def create
    @document_item = DocumentItem.new(document_item_params)

    respond_to do |format|
      if @document_item.save
        format.html { redirect_to @document_item, notice: "Document Item product was successfully created." }
        format.json { render :show, status: :created, location: @document_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_items/1 or /document_items/1.json
  def update
    respond_to do |format|
      if @document_item.update(document_item_params)
        format.html { redirect_to @document_item, notice: "Document Item product was successfully updated." }
        format.json { render :show, status: :ok, location: @document_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_items/1 or /document_items/1.json
  def destroy
    @document_item.destroy!

    respond_to do |format|
      format.html { redirect_to sales_products_path, status: :see_other, notice: "Document Item product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_item
      @document_item = DocumentItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def document_item_params
      params.expect(document_item: [ :sale_id, :product_id, :quantity, :total_price ])
    end
end
