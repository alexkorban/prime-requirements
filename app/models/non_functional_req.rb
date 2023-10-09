class NonFunctionalReq < ActiveRecord::Base
  belongs_to :project
  belongs_to :status

  normalize_attribute :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :business_reqs

  include Req
  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def links
    business_reqs.map{ |r| {"name" => r.full_name}}
  end

  def self.json_include
    {:methods => :links}
  end

  def update_links(req_links)
    ids = extract_link_ids(req_links)
    return if ids.nil?
    self.business_req_ids = ids[ProjectSequence::PREFIX[:business_req]]
  end

end
