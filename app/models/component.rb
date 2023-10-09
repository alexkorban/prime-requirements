class Component < ActiveRecord::Base
  belongs_to :functional_area
  belongs_to :stage
  belongs_to :project
  belongs_to :component_type
  has_many :rules
  has_many :high_level_reqs
  has_many :use_cases

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def links
    high_level_reqs.map { |r| {"name" => r.full_name}}
  end

  def self.json_include
    {:methods => :links}
  end

  def update_links(req_links)
#    ids = extract_link_ids(req_links)
#    return if ids.nil?
#    self.high_level_req_ids = ids[ProjectSequence::PREFIX[:high_level_req]]
  end

end
