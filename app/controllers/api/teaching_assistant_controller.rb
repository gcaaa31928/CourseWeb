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
