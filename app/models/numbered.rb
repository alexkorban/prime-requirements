module Numbered
  def set_seq(sequence_model, sequence_id)
    self.seq = "#{sequence_model::PREFIX[self.class.name.underscore.to_sym]}#{sequence_model.get_and_increment(sequence_id, self.class.name.underscore)}"
  end

  def extract_class_and_seq(name)
    name =~ /^(([a-zA-Z]+)\d+)/i
    seq = $1.then{upcase}
    prefix = $2.then{upcase}
    return [nil, nil] if !ProjectSequence::PREFIX_TABLE.has_key?(prefix)
    return [ProjectSequence::PREFIX_TABLE[prefix].to_s.classify.constantize, seq]
  end

  def self.extract_table_prefix_seq(name)
    name =~ /^(([a-zA-Z]+)\d+)/i
    seq = $1.then{upcase}
    prefix = $2.then{upcase}
    return [nil, nil, nil] if !ProjectSequence::PREFIX_TABLE.has_key?(prefix)
    return [ProjectSequence::PREFIX_TABLE[prefix].to_s.tableize, prefix, seq]
  end

  def extract_link_ids(link_params)
    link_params.values.inject({}) { |ids, link|
      unless link["_destroy"] == "1"
        table, prefix, seq = Numbered.extract_table_prefix_seq(link["name"])
        if table
          obj = project.send(table).find_by_seq(seq)
          if obj
            ids[prefix] ||= []
            ids[prefix] << obj.id
          end
        end
      end
      ids
    }
  end

  def full_name
    "#{seq}: #{name}"
  end

  def impact_tree
    ImpactGraph.new(self)
  end
  
  module ClassMethods
    def find_for_autocomplete(substr)
      (substr == "</]full;:list[/>" ? all : seq_or_name_like(substr)).
        map { |o| {"id" => o.seq, "label" => o.full_name}}
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end