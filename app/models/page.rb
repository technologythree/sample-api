class Page < ActiveRecord::Base
  attr_accessible :content, :published_on, :title
  validates :title, :presence => true
  validates :content, :presence => true
end
