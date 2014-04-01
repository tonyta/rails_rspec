class Post < ActiveRecord::Base
  scope :recent, -> { order("created_at DESC").limit(5) }

  before_save :titleize_title, :create_slug

  validates_presence_of :title, :content

  def create_slug
    self.slug = sluggify(self.title)
  end

  private

  def titleize_title
    self.title = title.titleize
  end

  def sluggify(str)
    #strip the string
    ret = str.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'

     #convert double underscores to single
     ret.gsub! /_+/,"_"

     #strip off leading/trailing underscore
     ret.gsub! /\A[-\.]+|[-\.]+\z/,""

     ret.downcase
  end
end
