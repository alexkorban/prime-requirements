class BusinessReq < ActiveRecord::Base
  belongs_to :project
  belongs_to :status

  belongs_to :rule
  belongs_to :high_level_req
  has_and_belongs_to_many :functional_reqs
  has_and_belongs_to_many :non_functional_reqs

  normalize_attribute :name

  validates_presence_of :name
  validates_uniqueness_of :name

  include Req
  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def links
    [functional_reqs, non_functional_reqs].map{|arr| arr.map{|r| {"name" => r.full_name}}}.flatten
  end

  def up_links
    [high_level_req].compact
  end

  def down_links
    [functional_reqs, non_functional_reqs].flatten
  end

  def down_link_count
    functional_reqs.size + non_functional_reqs.size
  end

  def self.json_include
    {:methods => :links}
  end

  def update_links(req_links)
    ids = self.extract_link_ids(req_links)
    return if ids.nil?
    self.functional_req_ids = ids[ProjectSequence::PREFIX[:functional_req]]
    self.non_functional_req_ids = ids[ProjectSequence::PREFIX[:non_functional_req]]
  end
end
