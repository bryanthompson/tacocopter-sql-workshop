require "rails_helper"

RSpec.describe Store, :type => :model do

  class Store < ActiveRecord::Base
    def self.good_params
      {
        name: "Testabarbara",
        sells_beer: true,
        zagat_rating: 5
      }
    end
  end

  # test basic validations
  it "returns a hash of known-to-be-good params for validation" do
    expect(Store).to respond_to(:good_params)
    expect(Store.good_params).to be_a(Hash)
    # not going to test every attribute of good params becasue our first
    # test will confirm that it is valid with those params, subsequent tests
    # will prove that changing exactly one attribute to invalid state breaks it
    # as would be expected, also we hard-coded the good_params here so it is
    # very easy to maintain and see going forward
  end

  it "is valid with known params" do
    c = Store.new(Store.good_params)
    expect(c).to be_valid
  end

  it "is not valid with a blank name" do
    c = Store.new(Store.good_params.merge({ name: ""}))
    expect(c).to be_invalid
  end
  it "is not valid with a missing name" do
    c = Store.new(Store.good_params.merge({ name: nil}))
    expect(c).to be_invalid
  end

  it "is not valid with blank sells_beer property" do
    c = Store.new(Store.good_params.merge({ sells_beer: ""}))
    expect(c).to be_invalid
  end
  it "is not valid with missing sells_beer property" do
    c = Store.new(Store.good_params.merge({ sells_beer: nil}))
    expect(c).to be_invalid
  end
  it "is valid falsey sells_bear property" do
    c = Store.new(Store.good_params.merge({ sells_beer: false}))
    expect(c).to be_invalid
  end

  it "is not valid with non-bool sells_beer property" do
    c = Store.new(Store.good_params.merge({ sells_beer: "probably"}))
    expect(c).to be_invalid
  end

  it "is not valid with blank zagat property" do
    c = Store.new(Store.good_params.merge({ zagat_rating: ""}))
    expect(c).to be_invalid
  end
  it "is not valid with missing zagat property" do
    c = Store.new(Store.good_params.merge({ zagat_rating: nil}))
    expect(c).to be_invalid
  end
  it "is not valid with non-numeric zagat property" do
    c = Store.new(Store.good_params.merge({ zagat_rating: "none"}))
    expect(c).to be_invalid
  end

  # test associations
  it "should be associated to a single city" do
    Store.reflect_on_association(:city).macro.should eq(:belongs_to)
  end

  # test our search business

  it "should have a specific class-level search method for our exercise" do
    expect(Store).to respond_to(:find_stores_with_taco_and_salsas)
  end


end

