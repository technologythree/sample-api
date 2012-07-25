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
  
  it "should list Published pages" do
    page_one = FactoryGirl.create(:page, published_on: 1.day.ago)
    page_two = FactoryGirl.create(:page, published_on: 1.month.ago)
    Page.published.should == [page_one, page_two]
  end
  
  it "should list Unpublished pages" do
    page_one = FactoryGirl.create(:page, published_on: DateTime.tomorrow)
    page_two = FactoryGirl.create(:page, published_on: nil)
    Page.unpublished.should == [page_one, page_two]
  end
  
  it "should Publish a page" do
    page_one = FactoryGirl.create(:page, published_on: nil)
    page_one.publish
    page_one.published_on.to_date.should == Page.find(1).published_on.to_date
  end
  
  it "should give a Word count of page title and content" do
    page_one = FactoryGirl.create(:page, published_on: nil)
    page_one.total_words.should == 2
  end
end
