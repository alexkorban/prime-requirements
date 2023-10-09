class HighLevelReq < ActiveRecord::Base
  belongs_to :project
  belongs_to :status
  belongs_to :rule
  belongs_to :use_case
  has_many :business_reqs

  normalize_attribute :name

  validates_presence_of :name
  validates_uniqueness_of :name

  include Req
  include Numbered

  def before_create
    set_seq(ProjectSequence, project.id)
  end

  def links
    business_reqs.map{|r| {"name" => r.full_name}}
  end

#  @graph_data = [{:id => 1, :name => "A", :adjacencies => [{:nodeTo => 2, :nodeFrom => 1}, {:nodeTo => 3, :nodeFrom => 1}]},
#                 {:id => 2, :name => "B", :adjacencies => [{:nodeTo => 4, :nodeFrom => 2}]},
#                 {:id => 3, :name => "C", :adjacencies => []},
#                 {:id => 4, :name => "D", :adjacencies => []}]

  def up_links
    [rule, use_case].compact
  end

  def down_links
    business_reqs
  end

  def down_link_count
    down_links.size + down_links.inject { |sum, dl| sum + dl.down_link_count }
  end


  def self.json_include
    {:methods => [:links]}
  end

  def update_links(req_links)
    ids = extract_link_ids(req_links)
    return if ids.nil?
    self.business_req_ids = ids[ProjectSequence::PREFIX[:business_req]]
  end
end