class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true
  validates :user_id, uniqueness: { scope: [:bookmarkable_id, :bookmarkable_type] }
end
