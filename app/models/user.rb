# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  job                    :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  p_key                  :string
#  provider               :string           default("email"), not null
#  pub_key                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  super_admin            :boolean          default(FALSE)
#  telegram               :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  wallet                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_p_key                 (p_key) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_wallet                (wallet) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_many :user_companies
  has_many :user_contributions
  has_many :participation_requests
  has_many :companies, through: :user_companies, dependent: :destroy
  has_many :contributions, through: :user_contributions, dependent: :destroy
  before_validation do
    self.uid = email if uid.blank?
  end
  after_create :new_wallet

  def new_wallet
    address_info = BlockcypherService.new.generate_address
    update(wallet: address_info['address'], p_key: address_info['private'], pub_key: address_info['public'])
  end

  def transfer_funds(amount, receiving_wallet)
    BlockcypherService.new.new_transaction(wallet, receiving_wallet, amount, p_key)
  end

  def get_balance
    BlockcypherService.new.address_balance(wallet)
  end
end
