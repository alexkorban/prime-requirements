class BusinessUnit < ActiveRecord::Base
  belongs_to :account
  has_many :teams
  accepts_nested_attributes_for :teams, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true  

  normalize_attribute :name

  validates_presence_of :name
  #validates_uniqueness_of :name

  def self.json_include
    {:include => {:teams => {:only=> [:id, :name]}}} 
  end
end
