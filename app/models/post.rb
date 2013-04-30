class Post < ActiveRecord::Base
  attr_accessible :url, :widget_id, :category_id, :title, :position, :body, :permalink, :metatags, :images_attributes
  has_many :images, :as => :owner, :class_name => "Image"
  belongs_to :widget
  belongs_to :category
  has_many :ratings, :as => :ratable, :class_name => 'Rating'
  has_many :comments, :class_name => "Comment"


  belongs_to :rating_category,
             :class_name => "Category",
             :foreign_key => :rating_category_id

  belongs_to :commenting_category,
             :class_name => "Category",
             :foreign_key => :commenting_category_id

  acts_as_url :title
  before_create :set_defaults
  before_create :save_permalink
  validates_presence_of :title

  accepts_nested_attributes_for :images
  #validates_uniqueness_of :permalink


  def rate(value, ip_address, user_id)
    if can_rate? ip_address
      #r = ratings.find_or_initialize_by_ip_address_id(IpAddress.find_by_value(ip_address).id)
      r = ratings.find_or_initialize_by_user_id(user_id)
      r.value = value
      r.ip_address_id = IpAddress.find_by_value(ip_address).id
      r.save!
    else
      errors.add :base, "You already rated this."
      false
    end
  end

  def comment(message, options = {})
    is_sub_comment = options[:is_sub_comment]
    c = comments.new(:ip_address_id => IpAddress.find_by_value(options[:ip_address]).id)
    c.message = message
    c.user_id = options[:user_id]
    c.user_agent = options[:user_agent]
    c.referer = options[:referer]
    c.spam? ? false : c.save
  end

  def can_rate?(ip_address)
    if User.current
      all_ratings = self.ratings.where(:user_id => User.current.id)
    else
      user_ips = IpAddress.find_by_value(ip_address).user.ip_address_ids
      all_ratings = self.ratings.where("ip_address_id IN(?)", user_ips)
    end
    if all_ratings.blank?
      true
    else
      # Can change his rating within 5 mins.
      (all_ratings.order("updated_at desc").first.created_at.to_time + 300) >= Time.now
    end
  end

  def avg_rate
    self.ratings.blank? ? 0 : (self.ratings.map(&:value).sum.to_f / self.ratings.count)
  end

  private

  def set_defaults
    unless self.rating_category #|| self.commenting_category
      self.rating_category = Category.where(:category_type => "rating").first
    end
  end

  def save_permalink
    permalink_value = self.title.to_url
    other = self.class.where("permalink LIKE '#{permalink_value}%'")
    unless other.empty?
      # Find the existing permalink with the highest number, and increment that number.
      # (If none of the existing permalinks have a number, this will evaluate to 1.)
      number = other.map { |o| o.send('permalink')[/-(\d+)$/, 1].to_i }.max + 1
      permalink_value += "-#{number.to_s}"
    end
    write_attribute('permalink', permalink_value)
  end

end
