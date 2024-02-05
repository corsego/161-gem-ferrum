class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.order(created_at: :desc)
  end

  def show
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        tmp = Tempfile.new(process_timeout: 30, timeout: 200, pending_connection_errors: true)
        browser = Ferrum::Browser.new
        browser.go_to(invoice_url(@invoice))
        sleep(0.3)
        browser.pdf(path: tmp)
        browser.quit
        send_file tmp, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:email, :product, :price, :quantity)
  end
end