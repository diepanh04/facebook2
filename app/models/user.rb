require 'carrierwave/orm/activerecord'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :friendships, foreign_key: :friend_b_id, dependent: :destroy
  # has_many :friends_a, through: :friendships, source: :friend_a

  has_many :inverse_friendships, class_name: :Friendship, foreign_key: :friend_a_id, dependent: :destroy
  # has_many :friends_b, through: :inverse_friendships, source: :friend_b

  has_many :friend_requests, foreign_key: :requester_id, dependent: :destroy 
  # has_many :recipients, through: :friend_requests

  has_many :friend_invitations, class_name: :FriendRequest, foreign_key: :recipient_id, dependent: :destroy 
  # has_many :requesters, through: :friend_invitations

  has_many :posts, inverse_of: 'creator'

  has_many :likes
  has_many :comments 

  has_one_attached :avatar

  mount_uploader :avatar, AvatarUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.avatar # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  class User < ApplicationRecord
    def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end

  # def getFriendships()
  #   return self.friendships.concat(self.inverse_friendships)
  # end 

  def is_friend(target)
    i = self.friendships.where(friend_a_id: self.id, friend_b_id: target.id).length
    j = self.friendships.where(friend_a_id: target.id, friend_b_id: self.id).length
    return true if(i+j >0)
    return false
  end 

  def friend_request_sent(target)
    i = self.friend_requests.where(recipient_id: target.id).length 
    return true if i > 0
    return false 
  end 
end 
