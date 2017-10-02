class User < ApplicationRecord
  has_secure_password

  validates :password, length: { minimum: 8 }
  validates :email, :name, presence: true
  validates :email, uniqueness: true
end
