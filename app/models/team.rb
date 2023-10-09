class Team < ActiveRecord::Base
  belongs_to :business_unit

  normalize_attribute :name

  validates_presence_of :name
end
