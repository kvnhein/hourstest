class Beer < ActiveRecord::Base
  validates :name, presence: true
  validates :abv, presence: true
  scope :name_like, -> (name) { where("name ilike ?", name)}

  belongs_to :venue

 before_save :default_values
  def default_values
    self.beer_status ||= 2
  end

  def beer_serving_size
      self.serving_size + " " +"oz." unless self.serving_size.nil? || self.serving_size.length < 1
  end
  def beer_abv
     if self.abv.length > 0
       "( #{self.abv}% ABV )"
     end
  end
end
