class Salsa < ActiveRecord::Base
  has_many :store_salsas, class_name: "StoreSalsa"
end
