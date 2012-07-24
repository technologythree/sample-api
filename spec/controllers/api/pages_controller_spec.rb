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
      get :edit, :id => page
      response.should render_template :json => "edit"
    end
    
    it "should get a xml edit page" do
      page = FactoryGirl.create(:page)
      get :edit, :id => page
      response.should render_template :xml => "edit"
    end
  end

  describe "POST #create" do
    it "should save a new page" do
      expect {
        post :create, :page => FactoryGirl.attributes_for(:page)
      }.to change(Page, :count).by(1)
    end
    
    it "should not save an invalid page" do
      expect {
        post :create, :page => FactoryGirl.attributes_for(:invalid_page)
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
end
