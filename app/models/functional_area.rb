class FunctionalArea < ActiveRecord::Base
  belongs_to :project
  belongs_to :solution
  has_many :components

  accepts_nested_attributes_for :components, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true

  normalize_attribute :name
  validates_presence_of :name

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def self.json_include
    {:include => {:components => {:only=> [:id, :name]}}}
  end
end
