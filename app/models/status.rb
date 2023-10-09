class Status < ActiveRecord::Base
  belongs_to :account
  has_many :use_cases
  has_many :high_level_reqs
  has_many :business_reqs
  has_many :functional_reqs
  has_many :non_functional_reqs
end
