class Message < ActiveRecord::Base
  belongs_to :store
  validates :to, presence: true
  validates :from, presence: true
  validates :message, presence: true
  
  
  def self.find_store(number)
    Store.find_by(phone: number)
  end
  
  def self.verify_key_and_secret(key, secret)
    key == ENV["QS_API_KEY"] && secret == ENV["QS_API_SECRET"]
  end
  
  def self.verify_sinch_origin(key)
    key == ENV["SINCH_SIGNED"]
  end
  
end
