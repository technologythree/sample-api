require 'spec_helper'

describe Page do
  it "should be a valid factory" do
    FactoryGirl.create(:page).should be_valid
  end
  
  it "should not save page without a title" do
    FactoryGirl.build(:page, title: nil).should_not be_valid
  end
  
  it "should not save page without content" do
    FactoryGirl.build(:page, content: nil).should_not be_valid
  end
  
  it "should save page without published on date" do
    FactoryGirl.build(:page, published_on: nil).should be_valid
  end
end
