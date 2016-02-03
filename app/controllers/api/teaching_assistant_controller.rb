class Api::TeachingAssistantController < ApplicationController


    def all
        retrieve
        teaching_assistants = TeachingAssistant.all
        render HttpStatusCode.ok(teaching_assistants.as_json(
            include: {
                course: {
                    only: [:id, :name, :academic_year]
                }
            }, only: [:id, :name, :class_name]
        ))
    end

    def add_student
        retrieve
        permitted = params.permit(:id, :name, :class_name ,:course_id)
        Student.create!(id: permitted[:id],
                        name: permitted[:name],
                        class_name: permitted[:class_name],
                        course_id: permitted[:course_id])
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private


    def retrieve
        require_headers
        retrieve_admin
        if @admin.nil?
            raise '憑證失效'
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
