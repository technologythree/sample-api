class Api::PagesController < ApplicationController
  respond_to :json, :xml
  
  before_filter :find_a_page, :only => [:show, :edit, :update, :destroy, :publish, :total_words]

  # curl http://localhost:3000/api/pages.json
  # curl http://localhost:3000/api/pages.xml
  def index
     @pages = Page.all
     respond_with(@pages)
   end

  # curl http://localhost:3000/api/pages/:id.json
  # curl http://localhost:3000/api/pages/:id.xml
   def show
     respond_with(@page)
   end
   
  # curl http://localhost:3000/api/pages/new.json
  # curl http://localhost:3000/api/pages/new.xml
   def new
     @page = Page.new
     respond_with(@page)
   end

   # curl -d "page[title]=Test" -d "page[content]=JSON Page" -X POST http://localhost:3000/api/pages.json
   # curl -d "page[title]=Test" -d "page[content]=XML Page" -X POST http://localhost:3000/api/pages.xml
   def create
     @page = Page.new(params[:page])
     if @page.save
       respond_with(@page, location: api_pages_url)
     else
       respond_with(@page)
     end
   end

   # curl http://localhost:3000/api/pages/:id/edit.json
   # curl http://localhost:3000/api/pages/:id/edit.xml
   def edit
     respond_with(@page)
   end

   # curl -d "page[title]=Test" -d "page[content]=JSON Page" -X PUT http://localhost:3000/api/pages/:id.json
   # curl -d "page[title]=Test" -d "page[content]=XML Page" -X PUT http://localhost:3000/api/pages/:id.xml
   def update
     if @page.update_attributes(params[:page])
       respond_with(@page)
     else
       respond_with(@page)
     end
   end

   # curl -X DELETE http://localhost:3000/api/pages/:id.json
   # curl -X DELETE http://localhost:3000/api/pages/:id.xml
   def destroy
     @page.delete
     @message = {message: 'Page deleted'}
     respond_with(@message)
   end

  # Will list all published Pages
  # curl http://localhost:3000/api/pages/published.json
  # curl http://localhost:3000/api/pages/published.xml
   def published
     @pages = Page.published
     respond_with(@pages)
   end

  # Will list all Unpublished Pages
   # curl http://localhost:3000/api/pages/unpublished.json
   # curl http://localhost:3000/api/pages/unpublished.xml
   def unpublished
     @pages = Page.unpublished
     respond_with(@pages)
   end
   
   # Will mark a page as updated
   # curl -X POST http://localhost:3000/api/pages/:id/publish.json
   # curl -X POST http://localhost:3000/api/pages/:id/publish.xml
   def publish
     @page.publish
     respond_with(@page, location: published_api_pages_url)
   end
   
   # Will return a total word count of title + content for a page
   # curl http://localhost:3000/api/pages/:id/total_words.json
   # curl http://localhost:3000/api/pages/:id/total_words.xml
   def total_words
     respond_with(total_words: @page.total_words)
   end
   

private

  def find_a_page
    @page = Page.find(params[:id])
  end

end
