class GraphsController < ApplicationController
  def show
    respond_to { |format|
      logger.info "PARAMS: " + params.inspect
      table, prefix, seq = Numbered.extract_table_prefix_seq(params[:id])
      project = current_user.account.projects.find(params[:project_id])
      format.json { render :json => project.send(table).find_by_seq(seq).impact_tree }
    }
  end
end
