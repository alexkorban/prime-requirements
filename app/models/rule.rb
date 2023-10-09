class Rule < ActiveRecord::Base
  belongs_to :project
  belongs_to :component
  belongs_to :rule_status
  belongs_to :rule_type
  has_many :high_level_reqs
  has_many :business_reqs

  normalize_attribute :name

  validates_presence_of :name

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def before_save
    self.status_updated_at = Time.zone.now if rule_status_id_changed? || new_record?
  end

  def links
    high_level_reqs.map { |r| {"name" => r.full_name}} + business_reqs.map{ |r| {"name" => r.full_name}}
  end

  def down_links
    high_level_reqs
  end

  def self.json_include
    {:methods => :links}
  end

  def update_links(links)
    ids = extract_link_ids(links)
    return if ids.nil?
    self.high_level_req_ids = ids[ProjectSequence::PREFIX[:high_level_req]]
    self.business_req_ids = ids[ProjectSequence::PREFIX[:business_req]]
  end
end
