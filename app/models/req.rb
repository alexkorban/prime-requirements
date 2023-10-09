module Req 
  def before_save
    self.status_updated_at = Time.zone.now if status_id_changed? || new_record?
  end
end
