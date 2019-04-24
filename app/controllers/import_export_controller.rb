class ImportExportController < ApplicationController
  def export_template
    respond_to do |format|
      format.html
      format.xlsx{response.headers["Content-Disposition"] = 'attachment; filename="template_import.xlsx"'}
    end
  end

  def import_pw
    import = ImportService.new params[:file], current_user
    import.import
    flash[:success] = "Students imported."
    redirect_to warehouses_path
  end
end
