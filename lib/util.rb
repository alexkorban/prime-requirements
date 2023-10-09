module Util
  def self.id_string_to_arr(s, options = {})
    s.split(".").flatten.map {|i| (i == "0" && options[:subst_zero]) ? nil : i.to_i}
  end
end