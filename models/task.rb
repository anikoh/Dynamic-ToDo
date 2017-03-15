class Task < ActiveRecord::Base
  belongs_to :user 
  validates :name, presence: true
  belongs_to :project
end
