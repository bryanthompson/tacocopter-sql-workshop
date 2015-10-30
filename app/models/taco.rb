class Taco < ActiveRecord::Base
  validates_presence_of :name, :vegetarian
  has_many :store_tacos, class_name: "StoreTaco"
end
