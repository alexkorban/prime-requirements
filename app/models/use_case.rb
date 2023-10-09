class UseCase < ActiveRecord::Base
  belongs_to :project
  belongs_to :component
  belongs_to :status

  has_many :high_level_reqs

  normalize_attribute :name

  validates_presence_of :name
  #validates_uniqueness_of :name, :case_sensitive => false

  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def before_save
    self.status_updated_at = Time.zone.now if status_id_changed? || new_record?
  end

  def links
    high_level_reqs.map{ |r| {"name" => r.full_name}}
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
  end

end
