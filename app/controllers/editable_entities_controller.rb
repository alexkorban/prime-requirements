class EditableEntitiesController < ApplicationController
  JSON_ESCAPE_MAP = {
      '\\'    => '\\\\',
      '</'    => '<\/',
      "\r\n"  => '\n',
      "\n"    => '\n',
      "\r"    => '\n',
      '"'     => '\\"' }

  before_filter :get_project
  
  # TODO: have to authorise the action here, can't just delete any object
  def destroy
    request.path_parameters['controller'].classify.constantize.destroy(params[:id])
    list
  end

  protected

  def get_project
    logger.info("in get_project: " + params.inspect)
    id = params[:project_id]
    id ||= params[:id]    # if the id isn't in :project_id, then it must be in :id
    @project = current_user.account.projects.find(id) if id
  end

  def assign_project_to_nested_items(nested_attrs)
    nested_attrs.each { |index, attrs|
      attrs[:project_id] ||= params[:project_id]
    }
  end

  def escape_json(json)
    json.gsub(/(\\|<\/|\r\n|[\n\r"])/) { JSON_ESCAPE_MAP[$1] }
  end

  def respond_with_json(partial)
    entity = yield
    entity_class = request.path_parameters['controller'].classify.constantize
    respond_to { |format|
      if !entity.nil? && entity.errors.empty?
        json_data = entity_class.respond_to?(:json_include) ? entity.to_json(entity_class.json_include) : entity.to_json
        # need to append the html data, hence the chomping of the closing brace
        format.json { render :json => "#{json_data.chomp!("}")}, \"html\": \"" + \
          escape_json(render_to_string(:partial => partial, :locals => { :o => entity}, :status => :accepted)) + "\"}"}
      else
        format.json { render :json => (entity.nil? ? { "error" => "nil object" } : entity.errors), :status => :unprocessable_entity }
      end
    }
  end

end
