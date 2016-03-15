require 'http_status_code'
class Api::ChartsController < ApplicationController

    def test
        git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse14.git")
        commits = git.log(999999)
        commits.each do |now|
            # Log.info(now.diff_parent.stats.to_s)
        end
        render HttpStatusCode.ok(count: 0)
    end

    def commits
        retrieve

        project = @student.group.project if @student.group
        course = @student.course
        CommitsChartJob.perform_later(course)
        your_commits_charts = {}
        commits = []
        data = {}
        if project.present?
            your_git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{project.id}.git")
            begin
                commits = your_git.log(999999)
                commits.each do |commit|
                    your_commits_charts[commit.date.strftime("%F")] ||= 0
                    your_commits_charts[commit.date.strftime("%F")] += 1
                end
            rescue
                nil
            end
        end

        chart = Chart.find_by(course_id: course.id)
        data['you'] = your_commits_charts.to_a.reverse.to_h
        data['average'] = chart.average_commits_count.to_a.reverse.to_h if chart
        data['high_standard'] = chart.high_standard_commits_count.to_a.reverse.to_h if chart
        data['low_standard'] = chart.low_standard_commits_count.to_a.reverse.to_h if chart

        render HttpStatusCode.ok(data)
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def line_of_code
        retrieve

        project = @student.group.project if @student.group
        course = @student.course
        LocChartJob.perform_later(course)
        your_loc_charts = {}
        commits = []
        data = {}
        if project.present?
            your_git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{project.id}.git")
            begin
                commits = your_git.log(999999)
                commits.each_cons(2) do |commit1, commit2|
                    your_loc_charts[commit1.date.strftime("%F")] ||= 0
                    your_loc_charts[commit1.date.strftime("%F")] += your_git.diff(commit2, commit1).insertions.to_i
                end
            rescue
                commits = []
            end
        end

        chart = Chart.find_by(course_id: course.id)
        data['you'] = your_loc_charts.to_a.reverse.to_h
        data['average'] = chart.average_loc.to_a.reverse.to_h if chart
        data['high_standard'] = chart.high_standard_loc.to_a.reverse.to_h if chart
        data['low_standard'] = chart.low_standard_loc.to_a.reverse.to_h if chart

        render HttpStatusCode.ok(data)
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def timelog
        retrieve
        course = @student.course
        sum_costs = TimeCost.joins(timelog: [project: [:group]]).where(groups:{course_id: course.id}).group('student_id', 'timelog_id', 'date').order('timelogs.date').sum('cost')
        my_sum_costs = TimeCost.joins(timelog: [project: [:group]]).where(student_id: @student.id).group('student_id', 'timelog_id', 'date').order('timelogs.date').sum('cost')
        your_time_cost_charts = {}
        high_standard_time_cost_charts = {}
        low_standard_time_cost_charts = {}
        average_time_cost_charts = {}
        all_data = {}
        sum_data = {}
        num_data = {}
        my_sum_costs.each do |key, cost|
            your_time_cost_charts[key[2].strftime("%F")] = cost
        end
        sum_costs.each do |key, cost|
            all_data[key[2].strftime("%F")] ||= []
            all_data[key[2].strftime("%F")] << cost
            sum_data[key[2].strftime("%F")] ||= 0
            sum_data[key[2].strftime("%F")] += cost
            num_data[key[2].strftime("%F")] ||= 0
            num_data[key[2].strftime("%F")] += 1
        end

        all_data.each do |key, data|
            data.sort!
            high_standard_time_cost_charts[key] = data[(num_data[key] * 0.75)]
            low_standard_time_cost_charts[key] = data[(num_data[key] * 0.25)]
            average_time_cost_charts[key] = sum_data[key] / num_data[key]
        end

        data = {}

        data['you'] = your_time_cost_charts.to_a.reverse.to_h
        data['average'] = average_time_cost_charts.to_a.reverse.to_h
        data['high_standard'] = high_standard_time_cost_charts.to_a.reverse.to_h
        data['low_standard'] = low_standard_time_cost_charts.to_a.reverse.to_h

        render HttpStatusCode.ok(data)
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin
        if @student.nil? and @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def retrieve_student
        if @access_token.present?
            @student = Student.find_by(access_token: @access_token)
        end
    end

    def retrieve_admin
        if @access_token.present?
            @teaching_assistant = TeachingAssistant.find_by(access_token: @access_token)
            @admin = Admin.find_by(access_token: @access_token)
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
