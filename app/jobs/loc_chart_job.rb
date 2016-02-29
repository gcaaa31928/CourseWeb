class LocChartJob < ActiveJob::Base
    queue_as :default

    APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

    def perform(course)
        groups = Group.joins(:students).where(course_id: course.id).uniq
        groups_gits = []
        groups.each do |group|
            if group.project
                git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{group.project.id}.git")
                groups_gits << git
            end
        end
        all_loc = {}
        sum_loc = {}
        group_count = {}
        groups_gits.each do |git|
            commits = []
            begin
                commits = git.log(999999)
                commits_by_date = {}
                commits.each do |commit|
                    commits_by_date[commit.date.strftime("%F")] ||= 0
                    commits_by_date[commit.date.strftime("%F")] += commit.diff_parent.insertions.to_i
                end
                commits_by_date.each do |key, value|
                    group_count[key] ||= 0
                    group_count[key] += 1
                    sum_loc[key] ||= 0
                    sum_loc[key] += value
                    all_loc[key] ||= []
                    all_loc[key] << value
                end
            rescue => e
            end
        end
        average_charts = {}
        high_standard_charts = {}
        low_standard_charts = {}

        group_count.each do |key, value|
            all_loc[key].sort!
            average_charts[key] = sum_loc[key] / value
            high_standard_charts[key] = all_loc[key][(value * 0.75).to_i]
            low_standard_charts[key] = all_loc[key][(value * 0.25).to_i]
        end
        chart = Chart.find_or_initialize_by(course_id: course.id)
        chart.average_loc = sort_by_date(average_charts)
        chart.high_standard_loc = sort_by_date(high_standard_charts)
        chart.low_standard_loc = sort_by_date(low_standard_charts)
        chart.save!
    end

    def sort_by_date(data)
        data.sort_by{|key, value| Date.parse(key).to_time.to_i }
    end
end
