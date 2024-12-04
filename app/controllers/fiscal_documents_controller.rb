class FiscalDocumentsController < ApplicationController
  before_action :set_fiscal_document, only: %i[show edit update destroy]

  # GET /fiscal_documents or /fiscal_documents.json
  def index
    @q = FiscalDocument.ransack(params[:q])
    @fiscal_documents = @q.result.includes(:customer)
  end

  # GET /fiscal_documents/1 or /fiscal_documents/1.json
  def show
  end

  # GET /fiscal_documents/new
  def new
    @fiscal_document = FiscalDocument.new
  end

  # GET /fiscal_documents/1/edit
  def edit
  end

  # POST /fiscal_documents or /fiscal_documents.json
  def create
    @fiscal_document = FiscalDocument.new(sale_params)

    respond_to do |format|
      if @fiscal_document.save
        format.html { redirect_to @fiscal_document, notice: "FiscalDocument was successfully created." }
        format.json { render :show, status: :created, location: @fiscal_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fiscal_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fiscal_documents/1 or /fiscal_documents/1.json
  def update
    respond_to do |format|
      if @fiscal_document.update(sale_params)
        format.html { redirect_to @fiscal_document, notice: "FiscalDocument was successfully updated." }
        format.json { render :show, status: :ok, location: @fiscal_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fiscal_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fiscal_documents/1 or /fiscal_documents/1.json
  def destroy
    @fiscal_document.destroy!

    respond_to do |format|
      format.html { redirect_to sales_path, status: :see_other, notice: "FiscalDocument was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fiscal_document
    @fiscal_document = FiscalDocument.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.expect(fiscal_document: [ :customer_id, :fiscal_scenario_id, :description ],
      customer: [ :name, :address ])
  end
end
