module Sequence
  def get_and_increment(id, seq_name)
    logger.info "WHERE: #{class_name.chomp("Sequence").foreign_key} = #{id}"
    seq = get_seq(id)
    if !seq
      self.create(class_name.chomp("Sequence").foreign_key => id)
      seq = get_seq(id)
    end
    puts seq.inspect
    value = seq[seq_name]
    seq[seq_name] += 1
    seq.save
    value
  end

  private
  def get_seq(id)
    self.find(:first, :conditions => "#{class_name.chomp("Sequence").foreign_key} = #{id}", :lock => true)
  end
end