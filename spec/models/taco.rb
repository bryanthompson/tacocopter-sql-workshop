require "rails_helper"

RSpec.describe Taco, :type => :model do

  class Taco < ActiveRecord::Base
    def self.good_params
      {
        name: "Crab",
        vegeterian: false
      }
    end
  end

  it "is valid with known params" do
    c = Taco.new(Taco.good_params)
    expect(c).to be_valid
  end

  # test associations
  it "should be associated to StoreTaco using existing table stores_tacos" do
    Taco.reflect_on_association(:store_tacos).macro.should eq(:has_many)
  end

end

