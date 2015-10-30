require "rails_helper"

RSpec.describe City, :type => :model do

  class City < ActiveRecord::Base
    def self.good_params
      {
        name: "Testabarbara"
      }
    end
  end

  # test basic validations
  it "returns a hash of known-to-be-good params for validation" do
    expect(City).to respond_to(:good_params)
    expect(City.good_params).to be_a(Hash)
    # not going to test every attribute of good params becasue our first
    # test will confirm that it is valid with those params, subsequent tests
    # will prove that changing exactly one attribute to invalid state breaks it
    # as would be expected, also we hard-coded the good_params here so it is
    # very easy to maintain and see going forward
  end

  it "is valid with known params" do
    c = City.new(City.good_params)
    expect(c).to be_valid
  end

  it "is not valid with a blank name" do
    c = City.new(City.good_params.merge({ name: ""}))
    expect(c).to be_invalid
  end
  it "is not valid with a missing name" do
    c = City.new(City.good_params.merge({ name: nil}))
    expect(c).to be_invalid
  end

  # test associations
  it "should be associated to stores" do
    City.reflect_on_association(:stores).macro.should eq(:has_many)
  end

end

