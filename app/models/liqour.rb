class Liqour < ActiveRecord::Base
  validates :name, presence: true
end
