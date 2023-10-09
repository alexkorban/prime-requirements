class RuleStatus < ActiveRecord::Base
  belongs_to :account
  has_many :rules
end
