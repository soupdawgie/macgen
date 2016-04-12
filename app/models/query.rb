class Query < ActiveRecord::Base
  validates :amount, :vendor, :start, :separator, presence: true
  validates :vendor, :start, length: { is: 6 }
  default_scope -> { order(created_at: :desc) }

end
