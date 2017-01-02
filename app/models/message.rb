class Message < ActiveRecord::Base
  belongs_to :store
  validates :to, presence: true
  validates :from, presence: true
  validates :message, presence: true
  
  
  def self.find_store(number)
    Store.find_by(phone: number)
  end
  
  def self.verify_key_and_secret(key, secret)
    key == ENV["qs_api_key"] && secret == ENV["qs_api_secret"]
  end
  
  def self.verify_sinch_origin(key)
    key == ENV["sinch_signed"]
  end
  
end
