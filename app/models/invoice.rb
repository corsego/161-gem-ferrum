class Invoice < ApplicationRecord
  validates :email, :product, :price, :quantity, :total, presence: true

  before_validation :calculate_total

  has_one_attached :pdf
  has_one_attached :image

  after_create_commit :generate_pdf
  after_create_commit :generate_image

  private

  def generate_pdf
    url = Rails.application.routes.url_helpers.invoice_url(self)
    tmp = Tempfile.new
    browser = Ferrum::Browser.new
    browser.go_to(url)
    browser.pdf(path: tmp.path)
    pdf.attach(io: File.open(tmp), filename: "invoice_#{id}.pdf")
    browser.quit
    tmp.close
    tmp.unlink
  end
  
  def generate_image
    url = Rails.application.routes.url_helpers.invoice_url(self)
    tmp = Tempfile.new
    browser = Ferrum::Browser.new
    browser.go_to(url)
    browser.screenshot(path: tmp.path, full: true, quality: 60, format: "png")
    image.attach(io: File.open(tmp), filename: "invoice_#{id}.png")
    browser.quit
    tmp.close
    tmp.unlink
  end

  def calculate_total
    return unless price && quantity

    self.total = price.to_i * quantity.to_i
  end
end