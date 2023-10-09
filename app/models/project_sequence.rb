class ProjectSequence < ActiveRecord::Base
  belongs_to :project
  
  PREFIX = { :stage => "ST", :solution => "S", :component => "C", :functional_area => "FA", :rule => "R",
             :high_level_req => "HLR", :functional_req => "FR", :non_functional_req => "NFR",
             :business_req => "BR", :use_case => "UC"}

  PREFIX_TABLE = PREFIX.invert
  
  extend Sequence
end
