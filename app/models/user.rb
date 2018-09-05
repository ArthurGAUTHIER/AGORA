class User < ApplicationRecord
    mount_uploader :photo, PhotoUploader

    validates :email, presence: true
    validates :password, presence: true
    validates :alias, presence: true
    has_many :reviews
    has_many :libraries
    has_many :media, through: :libraries
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_many :topics
    has_many :comments
end
