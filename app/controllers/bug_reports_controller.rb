class BugReportsController < ApplicationController
  before_action :set_bug_report, only: [:show, :edit, :update, :destroy]
  before_action :access_control, only: [:index, :show, :edit, :update, :destroy]

  # GET /bug_reports
  # GET /bug_reports.json
  def index
    @bug_reports = BugReport.all
  end

  # GET /bug_reports/1
  # GET /bug_reports/1.json
  def show
    @bug_report = BugReport.find(params[:id])
  end

  # GET /bug_reports/new
  def new
    @bug_report = BugReport.new
  end

  # GET /bug_reports/1/edit
  def edit

  end

  # POST /bug_reports
  # POST /bug_reports.json
  def create
    @bug_report = BugReport.new(bug_report_params)

    respond_to do |format|
      if @bug_report.save
        format.html { redirect_to @bug_report, notice: 'Bug report was successfully created.' }
        format.json { render :show, status: :created, location: @bug_report }
      else
        format.html { render :new }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bug_reports/1
  # PATCH/PUT /bug_reports/1.json
  def update
    respond_to do |format|
      if @bug_report.update(bug_report_params)
        format.html { redirect_to @bug_report, notice: 'Bug report was successfully updated.' }
        format.json { render :show, status: :ok, location: @bug_report }
      else
        format.html { render :edit }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bug_reports/1
  # DELETE /bug_reports/1.json
  def destroy
    @bug_report.destroy
    respond_to do |format|
      format.html { redirect_to bug_reports_url, notice: 'Bug report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug_report
      @bug_report = BugReport.find(params[:id])
    end

    def access_control
      if !user_signed_in?
        flash[:alert] = "You must be logged in to access this page"
        redirect_to welcome_index_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_report_params
      params.require(:bug_report).permit(:desc, :closed)
    end
end
