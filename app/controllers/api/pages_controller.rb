class Api::PagesController < ApplicationController
  respond_to :json, :xml
  
  before_filter :find_a_page, :only => [:edit, :update, :destroy, :publish, :total_words]
  
  def index
     @pages = Page.all
     respond_with(@pages)
   end

   def new
     @page = Page.new
     respond_with(@page)
   end

   def create
     @page = Page.new(params[:page])
     if @page.save
       respond_with(@page)
     else
       respond_with(@page.errors)
     end
   end

   def edit
     respond_with(@page)
   end

   def update
     if @page.update_attributes(params[:page])
       respond_with(@page)
     else
       respond_with(@page.errors)
     end
   end

   def destroy
     @page.delete
     @message = {message: 'The Page was successfully deleted'}
     respond_with(@message)
   end

   def published
     @pages = Page.published
     respond_with(@pages)
   end

   def unpublished
     @pages = Page.unpublished
     respond_with(@pages)
   end

   def publish
     @page.publish
     respond_with(@page, location: published_api_pages_url)
   end
   
   def total_words
     respond_with(@page.total_words)
   end

private

  def find_a_page
    @page = Page.find(params[:id])
  end

end
