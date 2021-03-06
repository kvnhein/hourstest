class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers => [:google_oauth2]
acts_as_voter
has_many :reservations
has_many :events
has_many :claims
has_many :reviews, dependent: :destroy
has_many :daily_specials
  validates :fullname, presence: true, length: {maximum: 50}
before_save :default_values
after_create :send_admin_mail
 
 
  def send_admin_mail
   EventMailer.welcome_email(self).deliver
  end

def self.users_cached
  Rails.cache.fetch("users_cached", expires_in: 1.hour) do
    User.all
  end
end 

def cached_user_experience
		Rails.cache.fetch([self,"user_experience"]) {experience}
end

def cached_user_id
		Rails.cache.fetch([self,"user_id"]) {id}
end

def default_values
    self.experience ||= 0
    self.num_verified ||= 0
    self.num_event_votes ||= 0
    self.num_claim_votes ||= 0
    self.num_events_saved ||= 0
 end
 
 
  
def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user

      return user
    else
    	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.fullname = auth.info.name
        user.provider  = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.image = auth.info.image
        user.password = Devise.friendly_token[0,20]
      end
    end
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resourse=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
      registered_user = User.where(:email => data.email).first
      if registered_user
        return registered_user
      else
        user = User.create(
          name: access_token.extra.raw_info.name,
          provider: access_token.provider,
          email: data.email,
          uid: access_token.uid,
          image: data.image,
          password: Devise.friendly_token[0,20],
        )
      end
    end
  end

  def admin?
  	self.id == 1 || self.admin == true
  end
  
  def super_user?
    if self.experience >= 10000
      return true
    end
  end
 
  def user_specials
    DailySpecial.where(user_id: self.id)
  end 
 
  def can_verify?
  if self.experience
    if self.experience < 0 
      return false
    else
      return true
    end
  end
  end
  
  def can_claim?
    if self.experience < 50
      return false
    else
      return true
    end
  end
  
  def can_create_hour
    if self.experience < 1000 
      return false
    else
      return true
    end
  end 
  
  def badges
    if self.experience < 10 
     return "extension"
    elsif self.experience >= 10 && self.experience < 50
      return "fingerprints"
    elsif self.experience >= 50 && self.experience < 100
      return "album"
    elsif self.experience >= 100 && self.experience < 150
      return "hearing"
    elsif self.experience >= 150
      return "mic"
    end
  end 
  
  def created_profile_badge
    return true
  end 
  
  def saved_first_hour
    if self.num_events_saved
      if self.num_events_saved >= 1
        return true
      end
    end 
  end 
  
  def count_events_saved
    self.increment!(:num_events_saved, by = 1)
    if (self.get_up_voted Event).count > 0 && (self.get_up_voted Event).count < 10 
      self.num_events_saved = 1 
      self.save!
    elsif (self.get_up_voted Event).count > 9 && (self.get_up_voted Event).count < 50 
      self.num_events_saved = 10 
      self.save!
    elsif (self.get_up_voted Event.all).count > 49
      self.num_events_saved = 50
      self.save!
    end 
  end
  def count_features_liked
    self.increment!(:num_features_liked, by = 1)
    if (self.get_up_voted DailySpecial).count > 0 && (self.get_up_voted DailySpecial).count < 10 
      self.num_features_liked = 1 
      self.save!
    elsif (self.get_up_voted DailySpecial).count > 9 && (self.get_up_voted DailySpecial).count < 50 
      self.num_features_liked = 10 
      self.save!
    elsif (self.get_up_voted DailySpecial).count > 49
      self.num_features_liked = 50
      self.save!
    end 
  end
  
  def verified_first_hour
    if self.num_verified
      if self.num_verified >= 1
        return true
      end 
    end
  end 
  
  def created_first_claim
    if Claim.where(user_id: self.id).count > 0
      return true 
    end
  end
  
  def liked_first_feature
  if self.num_features_liked
    if self.num_features_liked > 0
      return true
    end
  end
  end 
  
  def saved_10_hours
    if self.num_events_saved == 10
      return true
    end
  end 
  
  def liked_10_features
  if self.num_features_liked
    if self.num_features_liked > 10
      return true
    end
  end
  end
  
  def verified_10_hours
    if self.num_verified >= 10
      return true
    end 
  end 
  
  def created_feature
    if DailySpecial.where(user_id: self.id).count > 0 
      return true
    end 
  end 
  
  def voted_on_claim
    if self.num_claim_votes > 0
      return true 
    end
  end 
  
  def verified_50_hours
    if self.num_verified >= 50
      return true
    end 
  end 
  
  def saved_50_specials
    if self.num_events_saved == 50
      return true
    end
  end 
  
  def liked_50_features
  if self.num_features_liked
    if self.num_features_liked > 50
      return true
    end
  end
  end 
  
  
  def voting_power
    if self.experience < 1000 
     return 1
    elsif self.experience >= 1000 && self.experience < 2000
      return 2
    elsif self.experience >= 2000 && self.experience < 3000
      return 3
    elsif self.experience >= 3000 && self.experience < 4000
      return 4
    elsif self.experience >= 4000 && self.experience < 5000
      return 5
    elsif self.experience >= 5000 && self.experience < 6000
      return 6
    elsif self.experience >= 6000 && self.experience < 7000
      return 7
    elsif self.experience >= 7000 && self.experience < 8000
      return 8 
    elsif self.experience >= 8000 && self.experience < 9000
      return 9
    elsif self.experience >= 9000 && self.experience < 10000
      return 10 
    else 
      return 10 
    end
  end 
  
end
