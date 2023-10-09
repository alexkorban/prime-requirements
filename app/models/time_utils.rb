module TimeUtils
  def self.localisable(*symbols)
    symbols.each { |sym|
      class_eval %{
        def #{sym}_local
          I18n.l(#{sym})
        end
      }
    }
  end
end