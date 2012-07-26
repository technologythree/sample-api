require 'spec_helper'

describe Api::PagesController do
  
  describe 'GET #index' do
    it "should get json format list of pages" do
      page = FactoryGirl.create(:page)
      get :index, format: "json"
      response.should be_ok
      response.content_type.should eq "application/json"
      b = JSON.parse(response.body)[0]
      b['title'].should eq (page['title'])
    end
    
    it "should get xml format list of pages" do
      page = FactoryGirl.create(:page)
      get :index, format: "xml"
      response.should be_ok
      response.content_type.should eq "application/xml"
      b = Nokogiri::XML(response.body)
      b.css("title").text.should eq (FactoryGirl.build(:page).title) 
    end
  end
  
  describe 'GET #new' do
    it "should get a new json Page " do
      get :new, format: "json"
      response.should be_ok
      response.content_type.should eq "application/json"
      response.should render_template :json => "new"
    end
    
    it "should get a new xml page" do
      get :new, format: "xml"
      response.should be_ok
      response.content_type.should eq "application/xml"
      response.should render_template :xml => "new"
    end
  end

  describe 'GET #edit' do
    it "should get a json edit page" do
      page = FactoryGirl.create(:page)
      get :edit, id: page, format: "json"
      b = JSON.parse(response.body)
      b['title'].should eq (page['title'])
      response.should be_ok
      response.content_type.should eq "application/json"
      response.should render_template :json => "edit"
    end
    
    it "should get a xml edit page" do
      page = FactoryGirl.create(:page)
      get :edit, id: page, format: "xml"
      response.should be_ok
      response.content_type.should eq "application/xml"
      b = Nokogiri::XML(response.body)
      b.css("title").text.should eq (page.title) 
      response.should render_template :xml => "edit"
    end
  end

  describe "POST #create" do    
    it "should save a new page json format" do
      post :create, page: FactoryGirl.attributes_for(:page), format: "json"
      response.content_type.should eq "application/json"
      Page.count.should eq (1)
    end
    
    it "should not save an invalid page json format" do
      post :create, page: FactoryGirl.attributes_for(:invalid_page), format: "json"
      response.content_type.should eq "application/json"
      Page.count.should eq (0)
    end
    
    it "should save a new page xml format" do
      post :create, page: FactoryGirl.attributes_for(:page), format: "xml"
      response.content_type.should eq "application/xml"
      Page.count.should eq (1)
    end
    
    it "should not save an invalid page xml format" do
      post :create, page: FactoryGirl.attributes_for(:invalid_page), format: "xml"
      response.content_type.should eq "application/xml"
      Page.count.should eq (0)
    end
  end

  describe 'PUT #update' do
    before :each do
     @page = FactoryGirl.create(:page)
    end
    
    it "should populate requested page json format" do
      put :update, id: @page, page: FactoryGirl.attributes_for(:page), format: "json"
      response.content_type.should eq "application/json"
      @page.reload
      @page.title.should eq (FactoryGirl.build(:page).title)
      response.body.should be_blank
    end
    
    it "should populate requested page xml format" do
      put :update, id: @page, page: FactoryGirl.attributes_for(:page), format: "xml"
      response.content_type.should eq "application/xml"
      @page.reload
      @page.title.should eq (FactoryGirl.build(:page).title)
      response.body.should be_blank
    end
  end

  describe 'DELETE #destroy' do
    before :each do
     @page = FactoryGirl.create(:page)
    end
    
    it "should delete a page json format"do
      delete :destroy, id: @page, format: "json"
      Page.count.should eq (0)
    end
    
    it "should delete a page xml format"do
      delete :destroy, id: @page, format: "xml"
      Page.count.should eq (0)
    end
  end
  
  describe 'Page Publish methods' do
    it "should get json list of Published pages" do
      post :create, page: FactoryGirl.attributes_for(:page)
      get :published, format: "json"
      response.should be_ok
      response.content_type.should eq "application/json"
      b = JSON.parse(response.body)[0]
      b['title'].should eq (FactoryGirl.create(:page).title)
    end
    
    it "should get xml list of Published pages" do
      post :create, page: FactoryGirl.attributes_for(:page)
      get :published, format: "xml"
      b = Nokogiri::XML(response.body)
      response.should be_ok
      response.content_type.should eq "application/xml"
      b.css("title").text.should eq (FactoryGirl.create(:page).title)
    end
    
    it "should return Unpublished page count for nil published on date json format" do
       post :create, page: FactoryGirl.attributes_for(:page, published_on: nil)
       get :unpublished, format: "json"
       response.should be_ok
       response.content_type.should eq "application/json"
       b = JSON.parse(response.body)[0]
       b['title'].should eq (FactoryGirl.create(:page).title)
    end
    
    it "should return Unpublished page count for future published on date xml format" do
      post :create, page: FactoryGirl.attributes_for(:page, published_on: DateTime.tomorrow)
      get :unpublished, format: "xml"
      b = Nokogiri::XML(response.body)
      response.should be_ok
      response.content_type.should eq "application/xml"
      b.css("title").text.should eq (FactoryGirl.create(:page).title)
    end

    it "should mark a page as published json format" do
      page = FactoryGirl.create(:page, published_on: nil)
      post :publish, id: page, format: "json"
      b = JSON.parse(response.body)
      b['published_on'].should_not be_nil
    end
    
    it "should mark a page as published xml format" do
      page = FactoryGirl.create(:page, published_on: nil)
      post :publish, id: page, format: "xml"
      b = Nokogiri::XML(response.body)
      b.css("published-on").text.should_not be_nil
    end
     
    it "should return xml total page title and content count" do
      page = FactoryGirl.create(:page)
      get :total_words, id: page, format: "xml"
      response.should be_ok
      response.content_type.should eq "application/xml"
      b = Nokogiri::XML(response.body)
      b.css("total-words").text.should eq ("2")
    end
    
    it "should return json total page title and content count" do
      page = FactoryGirl.create(:page)
      get :total_words, id: page, format: "json"
      response.should be_ok
      response.content_type.should eq "application/json"
      b = JSON.parse(response.body)
      b['total_words'].should eq (2)
    end
  end
end
