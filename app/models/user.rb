class User < ApplicationRecord
  validates :name, :date_of_birth, :salary, :location, presence: true
end
