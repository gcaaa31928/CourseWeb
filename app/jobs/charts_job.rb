class ChartsJob < ActiveJob::Base
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
        all_commits = {}
        sum_commits = {}
        group_count = {}
        groups_gits.each do |git|
            commits = []
            begin
                commits = git.log(999999)
                commits_by_date = {}
                commits.each do |commit|
                    commits_by_date[commit.date.strftime("%F")] ||= 0
                    commits_by_date[commit.date.strftime("%F")] += 1
                end
                commits_by_date.each do |key, value|
                    group_count[key] ||= 0
                    group_count[key] += 1
                    sum_commits[key] ||= 0
                    sum_commits[key] += value
                    all_commits[key] ||= []
                    all_commits[key] << value
                end
            rescue => e
            end
        end
        average_charts = {}
        high_standard_charts = {}
        low_standard_charts = {}

        group_count.each do |key, value|
            all_commits[key].sort!
            average_charts[key] = sum_commits[key] / value
            high_standard_charts[key] = all_commits[key][(value * 0.75).to_i]
            low_standard_charts[key] = all_commits[key][(value * 0.75).to_i]
        end
        chart = Chart.find_or_initialize_by(course_id: course.id)
        chart.average_commits_count = sort_by_date(average_charts)
        chart.high_standard_commits_count = sort_by_date(high_standard_charts)
        chart.low_standard_commits_count = sort_by_date(low_standard_charts)
        chart.save!
    end

    def sort_by_date(data)
        data.sort_by{|key, value| Date.parse(key).to_time.to_i }
    end
end
