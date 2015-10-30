class StoreSalsa < ActiveRecord::Base
  # set_table_name is apparently deprecated
  self.table_name = "stores_salsas"
  belongs_to :store
  belongs_to :salsa
end
