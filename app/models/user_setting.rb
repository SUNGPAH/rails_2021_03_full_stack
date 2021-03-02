class UserSetting < ApplicationRecord
  validates :user_id, uniqueness: true, presence: true
end
