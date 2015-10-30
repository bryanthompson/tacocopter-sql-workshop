class Store < ActiveRecord::Base
  validates_presence_of :name, :sells_beer, :zagat_rating
  validates_numericality_of :zagat_rating # 1-5 starts, I imagine
  belongs_to :city

  has_many :store_tacos, table_name: "stores_tacos"
  has_many :tacos, through: :store_tacos

  has_many :store_salsas, table_name: "stores_salsas"
  has_many :salsas, through: :store_salsas

  def self.find_stores_with_taco_and_salsas selected_taco_ids = [], selected_salsa_ids = []

    selected_salsa_ids.map!(&:to_i).sort
    selected_taco_ids.map!(&:to_i).sort

    # Our data set isn't huge, so we can do a single query and just grab what we need.
    # Notes: 1. I'm not using .select("stores.name as store_name, cities.name as city_name") anymore because as soon as the .references for eager loading happens, it takes precedence over a limited select.
    # 2. This query grabs our store records along with their salsas and tacos, and we will do a simple map/reduce on the small data set.
    #
    #  SQL (416.9ms)  SELECT DISTINCT "stores"."id" AS t0_r0, "stores"."name" AS t0_r1, "stores"."city_id" AS t0_r2, "stores"."sells_beer" AS t0_r3, "stores"."zagat_rating" AS t0_r4, "stores_salsas"."id" AS t1_r0, "stores_salsas"."store_id" AS t1_r1, "stores_salsas"."salsa_id" AS t1_r2, "stores_salsas"."spiciness" AS t1_r3, "stores_tacos"."id" AS t2_r0, "stores_tacos"."store_id" AS t2_r1, "stores_tacos"."taco_id" AS t2_r2, "stores_tacos"."price" AS t2_r3 FROM "stores" INNER JOIN "cities" ON "cities"."id" = "stores"."city_id" LEFT OUTER JOIN "stores_salsas" ON "stores_salsas"."store_id" = "stores"."id" LEFT OUTER JOIN "stores_tacos" ON "stores_tacos"."store_id" = "stores"."id"
    #
    stores = self.joins(:city).includes(:store_salsas, :store_tacos).references(:store_salsas, :store_tacos, :city).distinct("stores.name").to_a

    stores.reject! do |store|
      store_salsa_ids = store.store_salsas.map(&:salsa_id).uniq.sort

      # by using & on the array of store's salsa ids vs the ones selected
      # in the form, we can find out how many they have in common.
      # If they _don't_ have the same number in common as selected, then we can't use them.
      # It would be easy to do this particular condition wrong and end up only getting stores that have *exactly* the selected salsas and no more.  This gets only stores that have _at least_ the selected salsas.
      (store_salsa_ids & selected_salsa_ids).count != selected_salsa_ids.count
    end

    stores.reject! do |store|
      store_taco_ids = store.store_tacos.map(&:taco_id).uniq.sort
      # same as above
      (store_taco_ids & selected_taco_ids).count != selected_taco_ids.count
    end

    # I feel like this is in as a trick, but it makes sense to me to consider it a mistake instead.  It
    # does not make sense to me to have duplicate store records - but it would make sense if a store had a
    # menu the menu had tacos and salsas.  But we aren't comparing menus, we're comparing stores, so this bit
    # of duplication feels like a mistake or a trap rather than design. If I had noticed this duplication earlier,
    # I would have surely wasted a lot less time chasing rabbits.
    #
    # [7] pry(main)> Store.find(4)
    # => #<Store:0x007ffa872e29d8 id: 4, name: "Lily's Tacos", city_id: 2, sells_beer: false, zagat_rating: 9>
    # [8] pry(main)> Store.find(7)
    # => #<Store:0x007ffa8730a2d0 id: 7, name: "Lily's Tacos", city_id: 2, sells_beer: false, zagat_rating: 8>

    # so I'll whack this list based on duplicate names too. Gonna use a pretty simple array

    stores.uniq! { |s| s.name }

    stores
  end

end

