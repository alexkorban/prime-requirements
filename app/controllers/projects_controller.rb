class ProjectsController < EditableEntitiesController
  NESTED_FIELDS = [{:stages_attributes => [:id, :name]}]
  INPUT_FIELDS = [:name, :description, :start_on, :finish_on] + NESTED_FIELDS
  param_accessible [:id, :prj, :sol, :fa, :cmp, {:project => [:name, :description, :start_on, :finish_on, :stages_attributes]}]
  before_filter :setup
  #uses_tiny_mce


  def index
    render :layout => "application"
  end

  def create
    respond_with_json("view") {           
      current_user.account.projects.create(params['project'])
    }
  end

  def list
    respond_to { |format|
      format.html { render :partial => "view", :collection => @projects, :as => :o, :status => :accepted }
    }
  end

  def update
    respond_with_json("view") {
      @project.update_attributes(params[:project])
      @project.stages(true)
      @project
    }
  end

  def show
    filter_params = [:sol, :fa, :cmp]

    if !params[:prj].nil?
      # remove prj from the query string
      redirect_to project_path((params[:prj] != params[:id]) ? params[:prj] : params[:id],
        :sol => params[:sol], :fa => params[:fa], :cmp => params[:cmp])
      return
    end

    #store filter params if project id not set or different params were submitted
    if user_session[:prj].nil? || filter_params.inject(false){|res, p| res || !params[p].nil?}
      user_session[:prj] = params[:id]
      filter_params.each {|p| user_session[p] = params[p] ? Util.id_string_to_arr(params[p]) : nil }
    end

    @selections = (filter_params + [:prj]).inject({}) {|res, p| res[p] = user_session[p]; res}

    component_ids = @project.get_component_ids(user_session)

    @use_cases = @project.apply_component_filter(component_ids, :use_cases)

    @high_level_reqs = @project.apply_component_filter(component_ids, :high_level_reqs) {
      @use_cases.map {|uc| uc.high_level_reqs}.flatten
    }
    @rules = @project.apply_component_filter(component_ids, :rules)

    @business_reqs = @project.apply_component_filter(component_ids, :business_reqs) {
      [@high_level_reqs, @rules].map {|parents| parents.map{|parent| parent.business_reqs}}.flatten.uniq
    }

    @functional_reqs = @project.apply_component_filter(component_ids, :functional_reqs) {
      @business_reqs.map{|br| br.functional_reqs}.flatten.uniq
    }
    @non_functional_reqs = @project.apply_component_filter(component_ids, :non_functional_reqs) {
      @business_reqs.map{|br| br.non_functional_reqs}.flatten.uniq
    }
  end

  def settings
  end

  protected

  def setup
    @locale = "en-GB"   # I'll need to convert Rails i18n locale name to jQuery UI locale name

#    if !current_user.account
#      current_user.account = Account.create(:name => "Unnamed company")
#      current_user.save!
#    end

    @projects = current_user.account.projects
    @filter_data = @projects.to_json(:only => :id,
                                     :include => {:solutions => {:only => [:id, :name, :project_id]},
                                                  :functional_areas => {:only => [:id, :name, :solution_id]},
                                                  :components => {:only => [:id, :name, :functional_area_id]}})
#    @filter_data = @projects.map { |p|
#      {p.id => p.solutions.to_json(:only => [:id, :name],
#        :include => {:functional_areas => {:only => [:id, :name], :include => {:components => {:only => [:id, :name]}}}})}
#    }.to_json
  end

end
