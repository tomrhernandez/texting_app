class Store < ActiveRecord::Base
  has_many :messages
  validates :name, presence: true
  validates :phone, presence: true
  validates :nabp, presence: true
  
  def self.verify_key_and_secret(key, secret)
    key == ENV["qs_api_key"] && secret == ENV["qs_api_secret"]
  end
  
end
