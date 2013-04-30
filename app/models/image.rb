class Image < ActiveRecord::Base
  attr_accessible :owner_id, :owner_type, :attachment
  belongs_to :owner, :polymorphic => true

  convert_options = "-quality 70 -resize"
  original_convert_options = "-quality 70 -strip -gravity center -extent"
  convert_options_for_logo = "-quality 90 -gravity center -resize"
  if Rails.env.development?

    has_attached_file :attachment,
                      :styles => {:mini => ["68x68^", :jpg], :small => ["242x88^", :jpg], :product => ["240x140^", :jpg], :large => ["650x210^", :jpg], :xlarge => ["1010x330^", :jpg], :original => ["1024x768^", :jpg]},
                      :convert_options => {:mini => "#{convert_options} 68x68",
                                           :small => "#{convert_options} 242x88",
                                           :product => "#{convert_options} 240x140",
                                           :large => "#{convert_options} 650x210 ",
                                           :xlarge => "#{convert_options} 1010x330",
                                           :original => "#{original_convert_options} 1024x768"},
                      :default_url => '/spree/products/:style/missing.png',
                      :default_style => :product,
                      :url => '/uploads/:id/:style/:basename.:extension',
                      :path => ':rails_root/public/uploads/:id/:style/:basename.:extension'
    #:path => ':rails_root/public/spree/products/:id/:style/:basename.:extension'
  else
    has_attached_file :attachment,
                      :styles => {:mini => ["68x68^", :jpg], :small => ["242x88^", :jpg], :product => ["240x140^", :jpg], :large => ["650x210^", :jpg], :xlarge => ["1010x330^", :jpg], :original => ["1024x768^", :jpg]},
                      :convert_options => {:mini => "#{convert_options} 68x68",
                                           :small => "#{convert_options} 242x88",
                                           :product => "#{convert_options} 240x140",
                                           :large => "#{convert_options} 650x210 ",
                                           :xlarge => "#{convert_options} 1010x330",
                                           :original => "#{original_convert_options} 1024x768"},
                      :default_style => :product,
                      :url => "/assets/photos/:style/:filename",
                      :path => "assets/photos/:style/:filename"


  end
end
