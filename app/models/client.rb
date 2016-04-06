class Client < ApplicationRecord
  PARTI_AUTH_API_TEST_CLIENT_NAME = 'Parti Auth API Test'
  PARTI_AUTH_EXAMPLE_CLIENT_NAME = 'Parti Auth Example'
  PARTI_AUTH_UI_CLIENT_NAME = 'Parti Auth UI'
  PARTI_AUTH_UI_TEST_CLIENT_NAME = 'Parti Auth UI Test'
  PARTI_USERS_API_TEST_CLIENT_NAME = 'Parti Users API Test'
  PARTI_USERS_UI_TEST_CLIENT_NAME = 'Parti Users UI Test'
  PARTI_USERS_UI_CLIENT_NAME = 'Parti Users UI'

  belongs_to :user_account
  has_many :test_accounts, inverse_of: :client
  has_many :access_tokens
  has_many :authorizations
  serialize :redirect_uris, JSON

  before_validation :setup, on: :create

  validates :identifier, presence: true, uniqueness: true
  validates :secret, presence: true
  validates :name, presence: true

  class << self
    def available_response_types
      ['code']
    end

    def available_grant_types
      ['authorization_code']
    end
  end

  private

  def setup
    self.identifier = SecureRandom.hex(16)
    self.secret = SecureRandom.hex(32)
  end
end
