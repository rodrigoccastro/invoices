class Invoice < ApplicationRecord
  validates :number, presence: true
  validates :date, presence: true
  validates :company, presence: true
  validates :payer, presence: true
  validates :value, presence: true
  validates :emails, presence: true
  belongs_to :user
end
