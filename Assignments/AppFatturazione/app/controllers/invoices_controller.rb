class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  def default
  end

  def pdf

    if (params.has_key?(:hour_ids))
      client_id = (Hour.find_by id: params[:hour_ids].first).client_id
      params[:hour_ids].each do |value|
        hour = Hour.find_by id: value
        if client_id != hour.client_id
          redirect_to :controller => 'hours', :action => 'index', error_message: "Non puoi fatturare due clienti diversi nella stessa fattura"
          return
        end
      end
      @new_invoice = Invoice.create
      params[:hour_ids].each do |value|
        @hour = Hour.find_by id: value
        @user = User.find_by id: @hour.user_id
        @client = Client.find_by id: @hour.client_id
        @hour.invoice_id = @new_invoice.id
        @hour.is_fatturata = true
        @new_invoice.total_amount = @new_invoice.total_amount + (@hour.end_time - @hour.start_time).to_i * (@user.tarif/3600)
        @hour.save if @hour.valid?
        @new_invoice.save if @new_invoice.valid?
      end
      @hours_to_bill = Hour.where(invoice_id: @new_invoice.id)
    else
      redirect_to :controller => 'hours', :action => 'index', error_message: "Devi selezionare almeno un ora da fatturare"
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:id, :total_amount)
    end
end
