class Task < ApplicationRecord
  belongs_to :list
  validates  :content, presence: true, uniqueness: { scope: :list_id }

  def deadline_soon?
    self.deadline ? self.deadline <= DateTime.now - 2.hours : false
  end
end
