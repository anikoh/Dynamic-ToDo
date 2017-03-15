class Project < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :category
  has_many :tasks
end
