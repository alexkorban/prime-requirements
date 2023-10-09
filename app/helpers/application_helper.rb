# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def l(val)
    return h("<not set>") if val.nil?
    I18n.l val
  end

  def show_flash
    text = flash.now[:notice]
    text ||= flash.now[:error]
    text ||= flash.now[:alert]
    div_class = flash.now[:error] ? "flash ui-state-error" : "flash ui-state-highlight"
    text && !text.empty? ? "<div class = '#{div_class}'>#{text}</div>" : nil
  end

  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys

    if object = options.delete(:object)
      objects = Array.wrap(object)
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end

    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}

      if options.include?(:id)
        value = options[:id]
        html[:id] = value unless value.blank?
      else
        html[:id] = 'error_explanation'
      end

      html[:class] = "flash ui-state-error ui-corner-all"
      options[:object_name] ||= params.first

      I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
#        header_message = if options.include?(:header_message)
#          options[:header_message]
#        else
#          object_name = options[:object_name].to_s
#          object_name = I18n.t(object_name, :default => object_name.gsub('_', ' '), :scope => [:activerecord, :models], :count => 1)
#          locale.t :header, :count => count, :model => object_name
#        end
        header_message = options.include?(:header_message) ? options[:header_message] : "Alert! Alert!"
        #message = options.include?(:message) ? options[:message] : locale.t(:body)
        message = options.include?(:message) ? options[:message] : "Slight issues with the form:"
        error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, ERB::Util.html_escape(msg)) } }.join.html_safe

        contents = ''
        contents << content_tag(options[:header_tag] || :b, header_message) unless header_message.blank?
        contents << content_tag(:p, message) unless message.blank?
        contents << content_tag(:ul, error_messages)

        content_tag(:div, contents.html_safe, html)
      end
    else
      ''
    end
  end
end
