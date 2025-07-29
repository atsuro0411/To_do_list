class Post < ApplicationRecord
  validates :content, presence: true
  validates :due_date, presence: true
end
