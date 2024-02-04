class Invoice < ApplicationRecord
  validates :email, :product, :price, :quantity, :total, presence: true

  before_validation :calculate_total

  private

  def calculate_total
    return unless price && quantity

    self.total = price.to_i * quantity.to_i
  end
end