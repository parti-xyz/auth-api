class Account < ApplicationRecord
  has_one :parti, class_name: 'ConnectParti', inverse_of: :account
  has_one :internal, class_name: 'ConnectInternal', inverse_of: :account
  has_many :clients
  has_many :authorizations
  has_many :access_tokens
  has_many :id_tokens

  before_validation :setup, on: :create
  validates :identifier, presence: true, uniqueness: true

  private

  def setup
    self.identifier = SecureRandom.hex(8)
  end
end