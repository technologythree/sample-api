require 'spec_helper'

describe Api::PagesController do
  
  describe 'GET #index' do
    it "should populate an array of pages" do
      page = FactoryGirl.create(:page)
      get :index
      assigns(:pages).should == [page]
    end
    
    it "renders the index json view" do
      get :index
      response.should render_template :json => "index"      
    end
    
    it "should render xml view" do
      get :index
      response.should render_template :xml => "index"      
    end
  end
  
  describe 'GET #new' do
    it "should get a new Page " do
      get :new
      assigns(:page).should be_a_new(Page)
    end
    
    it "should get a new json template" do
      get :new
      response.should render_template :json => "new"
    end
    
    it "should get a new xml template" do
      get :new
      response.should render_template :xml => "new"
    end
  end

  describe 'GET #edit' do
    it "should get a json edit page" do
      page = FactoryGirl.create(:page)
      get :edit, id: page
      response.should render_template :json => "edit"
    end
    
    it "should get a xml edit page" do
      page = FactoryGirl.create(:page)
      get :edit, id: page
      response.should render_template :xml => "edit"
    end
  end

  describe "POST #create" do
    it "should save a new page" do
      expect {
        post :create, page: FactoryGirl.attributes_for(:page)
      }.to change(Page, :count).by(1)
    end
    
    it "should not save an invalid page" do
      expect {
        post :create, page: FactoryGirl.attributes_for(:invalid_page)
      }.to_not change(Page, :count)
    end
  end

  describe 'PUT #update' do
    before :each do
     @page = FactoryGirl.create(:page)
    end
    
    it "should populate requested page" do
      put :update, id: @page, page: FactoryGirl.attributes_for(:page)
      assigns(:page).should eq(@page)
    end
    
    it "should update page attributes" do
      put :update, id: @page, page: FactoryGirl.attributes_for(:page, title: "This is a test title")
      @page.reload
      @page.title.should eq("This is a test title")
    end
  end

  describe 'DELETE #destroy' do
    before :each do
     @page = FactoryGirl.create(:page)
    end
    
    it "should delete a page"do
      expect{
       delete :destroy, id: @page
      }.to change(Page,:count).by(-1)
    end
  end
  
  describe 'Page Publish methods' do
    it "should get json list of Published pages" do
      post :create, page: FactoryGirl.attributes_for(:page)
      get :published, format: "json"
      response.should be_ok
      response.content_type.should eq "application/json"
      b = JSON.parse(response.body)
      b.should be_a_kind_of(Array)
      b.size.should eq 1
      b[0]['title'].should eq (FactoryGirl.create(:page).title)
    end
    
    it "should get xml list of Published pages" do
      post :create, page: FactoryGirl.attributes_for(:page)
      get :published, format: "xml"
      b = Nokogiri::XML(response.body)
      response.should be_ok
      response.content_type.should eq "application/xml"
      b.css("title").text.should eq (FactoryGirl.create(:page).title)
    end
    
    it "should return Unpublished page count" do
       post :create, page: FactoryGirl.attributes_for(:page, published_on: nil)
       get :unpublished, format: "json"
       response.should be_ok
       response.content_type.should eq "application/json"
       b = JSON.parse(response.body)
       b.should be_a_kind_of(Array)
       b.size.should eq 1
       b[0]['title'].should eq (FactoryGirl.create(:page).title)
    end
    
    it "should return Unpublished page count for future publish date" do
      post :create, page: FactoryGirl.attributes_for(:page, published_on: DateTime.tomorrow)
      get :unpublished, format: "xml"
      b = Nokogiri::XML(response.body)
      response.should be_ok
      response.content_type.should eq "application/xml"
      b.css("title").text.should eq (FactoryGirl.create(:page).title)
    end

    it "should mark a page as published" do
      page = FactoryGirl.create(:page, published_on: nil)
      post :publish, id: page, format: "json"
      b = JSON.parse(response.body)
      b['published_on'].should_not be_nil
    end
    
    it "should mark a page as published" do
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
      b.css("total-words").text.should eql("2")
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
