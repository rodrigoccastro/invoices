class User < ApplicationRecord
  VALID_EMAIL_FORMAT= /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true, length: {maximum: 260}, format: { with: VALID_EMAIL_FORMAT}, uniqueness: {case_sensitive: false}
  validates :token_main, uniqueness: {case_sensitive: true}
  validates :token_temp, uniqueness: {case_sensitive: true}
  before_save { self.email = email.downcase }
  has_many :invoices
end
