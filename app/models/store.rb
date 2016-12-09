class Store < ActiveRecord::Base
  has_many :messages
  validates :name, presence: true
  validates :phone, presence: true
  validates :nabp, presence: true
end
