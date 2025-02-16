# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  # Sleep records relationship
  has_many :sleep_records, dependent: :destroy

  # Follow relationships (Self-referential Association)
  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  has_many :follower_relationships, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
end
