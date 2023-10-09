class Project < ActiveRecord::Base
  belongs_to :account

  has_many :stages
  accepts_nested_attributes_for :stages, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true

  has_many :solutions
  has_many :functional_areas
  has_many :components

  has_many :high_level_reqs
  has_many :business_reqs
  has_many :functional_reqs
  has_many :non_functional_reqs
  has_many :use_cases
  has_many :rules

  has_one :project_sequence

  # these are necessary to make jQueryUI calendars work
  attr_accessor :start_on_ui, :finish_on_ui

  normalize_attribute :name

  validates_presence_of :name

  def self.json_include
    {:include => {:stages => {:only=> [:id, :name]}}} 
  end

  # it turns out that you can't pass an array containing nil to find_all_* (nil is ignored), so instead you have to
  # make a separate find call for nil
  def get_component_ids(params)
    if params[:cmp] && !params[:cmp].empty?
      ids = Util.id_string_to_arr(params[:cmp])
      arr = components.find_all_by_id(ids)
      arr << 0 if ids.include?(0)
      return arr
    end
    if params[:fa] && !params[:fa].empty?
      fa_ids = Util.id_string_to_arr(params[:fa])
      arr = components.find_all_by_functional_area_id(fa_ids).map(&:id)
      arr = arr + components.find_all_by_functional_area_id(nil).map(&:id) if fa_ids.include?(0)
      return arr
    end
    if params[:sol] && !params[:sol].empty?
      sol_ids = Util.id_string_to_arr(params[:sol])
      fa_ids = functional_areas.find_all_by_solution_id(sol_ids).map(&:id)
      fa_ids = fa_ids + functional_areas.find_all_by_solution_id(nil).map(&:id) if sol_ids.include?(0)
      # note that fa_ids can't contain 0 in this case as we are deriving fa_ids from sol_ids
      return components.find_all_by_functional_area_id(fa_ids).map(&:id)
    end
    components.all.map(&:id) + [0]
  end

  def apply_component_filter(component_ids, table_sym)
    entities = send(table_sym)
    arr = block_given? ? yield(entities) : entities.find_all_by_component_id(component_ids)
    # it turns out that you can't pass an array containing nil to find_all_* (nil is ignored), so instead you have to
    # make a separate find call for nil
    arr = arr + entities.find_all_by_component_id(nil) if component_ids.include?(0) && entities.respond_to?(:find_all_by_component_id)
    arr
  end

  def req_status_data
    res = {:label => account.statuses.map(&:name), :values => []}
    [:high_level_reqs, :business_reqs, :functional_reqs, :non_functional_reqs].each { |table|
      values = account.statuses.map { |status| send(table).find_all_by_status_id(status).then{size} }
      res[:values] << {:label => table.to_s.split("_").map {|name| name[0].chr }.join.upcase, :values => values}
    }
    res
#    solutions.each { |sol|
#      sol.functional_areas.each { |fa|
#        fa.components.each { |c|
#          c.high_level_reqs.size + c.high_level_reqs.inject {|sum, hlr| sum + hlr.down_link_count }
#        }
#      }
#    }
  end

#  def create_item(type, item_attrs)
#    item = nil
#    ProjectSequence.transaction {
#      item = type.singularize.camelize.constantize.new(item_attrs) { |i|
#        i.seq = "#{ProjectSequence::PREFIX[type.singularize]}#{ProjectSequence.get_and_increment(self.id, type.singularize)}"
#        raise ActiveRecord::Rollback if !i.save
#        self.send(type) << i
#      }
#    }
#    item
#  end

#  def functional_areas_for_select
#    functional_areas.inject({}) { |hash, fa| hash[fa.seq] = fa.id; hash }
#  end
end
