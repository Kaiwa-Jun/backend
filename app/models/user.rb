class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, presence: true, if: :password_required?
  # Set default value for provider
  attribute :provider, :string, default: 'google_oauth2'

  private

  def password_required?
    provider.blank?
  end
end
