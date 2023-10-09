class Account < ActiveRecord::Base
  has_many :users
  has_many :projects

  has_many :business_units
  
  has_one :account_sequence

  has_many :statuses

  accepts_nested_attributes_for :statuses, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true  

  has_many :rule_statuses

  accepts_nested_attributes_for :rule_statuses, :reject_if => lambda { |a| a[:name].blank? || (a[:id].nil? && a[:destroy] == "1")},
                                :allow_destroy => true  

#  def create_project(project_attrs)
#    proj = nil
#    AccountSequence.transaction {
#      proj = Project.new(project_attrs) { |p|
#        p.seq = "#{AccountSequence::PREFIX[:project]}#{AccountSequence.get_and_increment(self.id, :project)}"
#        raise ActiveRecord::Rollback if !p.save
#      }
#      proj.project_sequence = ProjectSequence.new
#      self.projects << proj
#    }
#    proj
#  end

  def teams
    business_units.inject([]) { |teams, bu| teams += bu.teams; teams }
  end

  def after_create
    # add default req/use case statuses
    ["Draft", "WIP", "P-Review", "B-Review", "Pending", "Approved", "Rejected", "Withdrawn"].each { |status|
      statuses.create(:name => status)
    }

    # add default rule statuses
    ["Draft", "Pending", "Final"].each { |status| rule_statuses.create(:name => status) }
  end
end
