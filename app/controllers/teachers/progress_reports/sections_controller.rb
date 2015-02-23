class Teachers::ProgressReports::SectionsController < ApplicationController
  before_action :authorize!
  layout 'scorebook'

  def index
    if request.xhr?
      section_data = Section.for_progress_report(current_user, params)
      section_ids = section_data.map {|s| s['id']}
      classrooms = Classroom.for_progress_report(section_ids, current_user, params)
      units = Unit.for_sections(section_ids, current_user)
      students = User.for_progress_report(section_ids, current_user, params)
      render json: {
        sections: section_data,
        classrooms: classrooms,
        students: students,
        units: units
      }
    end
  end

  private

  def authorize!
    return if current_user.try(:teacher?)
    render nothing: true, status: :unauthorized
  end
end