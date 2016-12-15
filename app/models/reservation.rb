class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_special
end
