class Song < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :music_url, presence: true, uniqueness: { scope: :user }, http_url: true
end
