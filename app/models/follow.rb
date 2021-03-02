class Follow < ApplicationRecord
  validates :user_id, uniqueness: { scope: :target_user_id }
end
