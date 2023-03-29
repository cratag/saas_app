class Member < ApplicationRecord
  belongs_to :tenant
  acts_as_tenant(:account)
end
