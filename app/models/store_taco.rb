class StoreTaco < ActiveRecord::Base
  # set_table_name is apparently deprecated
  self.table_name = "stores_tacos"
  belongs_to :store
  belongs_to :taco
end
