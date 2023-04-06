class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, presence: true, if: :password_required?

  has_many :photos

  private

  def password_required?
    provider.blank?
  end
end
