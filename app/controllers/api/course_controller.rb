class Api::CourseController < ApplicationController

    def all
        retrieve
        if @admin or @teaching_assistant
            courses = Course.all
            return render HttpStatusCode.ok(courses.as_json(
                only: [:id, :name, :academic_year])
            )
        end
        render HttpStatusCode.forbidden
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
