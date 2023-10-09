class AccountSequence < ActiveRecord::Base
  belongs_to :account
  
  PREFIX = { :project => "P" }

  extend Sequence
end
