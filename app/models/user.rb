class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates_presence_of :email, :password_digest
  validates :email, uniqueness: true
  has_secure_password
end
