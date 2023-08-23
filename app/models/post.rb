class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :descritption, presence: true, length: { minimum: 30}
end
