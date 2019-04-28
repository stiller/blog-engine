class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable

  validates_presence_of :body
end
