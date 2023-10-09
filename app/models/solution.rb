class Solution < ActiveRecord::Base
  belongs_to :project

  normalize_attribute :name
  validates_presence_of :name

  has_many :functional_areas
  accepts_nested_attributes_for :functional_areas, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true  

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def self.json_include
    {:include => {:functional_areas => {:only=> [:id, :name]}}} 
  end

  def components
    functional_areas.map {|fa| fa.components}.flatten
  end

end
