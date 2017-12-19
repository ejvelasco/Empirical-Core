class ProgressReports::ActivitiesScoresByClassroom
  def self.results(classroom_ids)
    ActiveRecord::Base.connection.execute(
      "SELECT classrooms.name AS classroom_name, students.id AS student_id, students.name, AVG(activity_sessions.percentage) AS average_score, COUNT(activity_sessions.id) AS activity_count, classrooms.id AS classroom_id FROM classroom_activities
      JOIN activity_sessions ON classroom_activities.id = activity_sessions.classroom_activity_id
      JOIN classrooms ON classrooms.id = classroom_activities.classroom_id
      JOIN users AS students ON students.id = activity_sessions.user_id
      WHERE classroom_activities.classroom_id IN (#{classroom_ids.join(', ')}) AND activity_sessions.is_final_score = TRUE AND classroom_activities.visible = true
      GROUP BY classrooms.name, students.id, students.name, classrooms.id").to_a
  end
end