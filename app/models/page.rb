class Page < ActiveRecord::Base
  attr_accessible :content, :published_on, :title
  validates :title, :presence => true
  validates :content, :presence => true
  
  scope :published,  lambda { {:conditions => [ 'published_on <= ? AND published_on IS NOT NULL', DateTime.now ], :order => "published_on DESC" }}
  scope :unpublished, lambda { {:conditions => ['published_on > ? OR published_on IS NULL', DateTime.now ], :order => "published_on DESC" }}
  
  def publish
    self.published_on = DateTime.now
    save
  end
  
  def total_words
    self.title.split(' ').length + self.content.split(' ').length
  end

end
