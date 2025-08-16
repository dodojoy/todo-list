class Task < ApplicationRecord
  belongs_to :user

  before_save :set_concluded_at

  private

  def set_concluded_at
    self.concluded_at = concluded? ? Time.current : nil if concluded_changed?
  end
end
