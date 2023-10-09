class Stage < ActiveRecord::Base
  belongs_to :project
  has_many :components

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def full_name
    name
  end
end
