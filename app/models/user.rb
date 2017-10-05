class User < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_secure_password

  validates :email, :name, presence: true
  validates :email, uniqueness: true
  validates_length_of :password, minimum: 8, allow_blank: true
end
