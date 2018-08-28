class User < ApplicationRecord
    validates :email, presence: true
    validates :password, presence: true
    validates :alias, presence: true
    has_many :reviews
    has_many :libraries
    has_many :media, through: :library
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
