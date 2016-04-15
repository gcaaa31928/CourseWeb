namespace :move_up_validation_of_timelog do
    task :process => :environment do
        desc "Move up validation date"
        moved_source = -1
        moved_destination = -2
        project_id = nil
        if project_id
            project = Project.find_by(id: project_id)
            timelogs = project.timelogs.order(:week_no)
            acceptance = timelogs[moved_source].acceptance
            timelogs[moved_source].acceptance = false
            timelogs[moved_destination].acceptance = acceptance
            timelogs[moved_source].save!
            timelogs[moved_destination].save!
        end
        Project.all.each do |project|
            timelogs = project.timelogs.order(:week_no)
            acceptance = timelogs[moved_source].acceptance
            timelogs[moved_source].acceptance = false
            timelogs[moved_destination].acceptance = acceptance
            timelogs[moved_source].save!
            timelogs[moved_destination].save!
        end
    end
end
