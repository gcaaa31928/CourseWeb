require 'http_status_code'
class Api::ChartsController < ApplicationController

    def test
        git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse2.git")
        Log.info(git.log(999999).since('1 weeks ago').to_s)
        render HttpStatusCode.ok(count: 0)
    end

    def commits
        retrieve

        project = @student.group.project
        since_date = project.created_at.to_date
        until_date = since_date + 1.week
        course = @student.course
        ChartsJob.perform_later(course)
        your_git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{project.id}.git")
        your_commits_charts = {}
        commits = []
        begin
            commits = your_git.log(999999)
        rescue
            commits = []
        end
        commits.each do |commit|
            your_commits_charts[commit.date.strftime("%F")] ||= 0
            your_commits_charts[commit.date.strftime("%F")] += 1
        end
        chart = Chart.find_by(course_id: course.id)
        data = {
            you: your_commits_charts.to_a.reverse.to_h
        }
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