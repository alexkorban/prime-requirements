# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


def create(model, *names)
  names.each { |name|
    model.create(:name => name) if !model.find_by_name(name)
  }
end

create(RuleType, "Internal", "External")
create(ComponentType, "Existing", "New")

create(Role, "admin")