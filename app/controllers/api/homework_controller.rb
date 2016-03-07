class Api::HomeworkController < ApplicationController

    def add
        retrieve
        permitted = params.permit(:name, :course_id)
        homework = Homework.new(name: permitted[:name], course_id: permitted[:course_id])
        homework.save!
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def all
        retrieve
        permitted = params.permit(:name, :course_id)
        homeworks = Homework.where(course_id: permitted[:course_id])
        render HttpStatusCode.ok(homeworks.as_json(only: [:id, :name]))
    end

    def hand_in_homework
        retrieve
        permitted = params.permit(:homework_id, :student_id)
        DeliverHomework.find_or_create_by(student_id: permitted[:student_id].to_i, homework_id: permitted[:homework_id].to_i)
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def cancel_hand_in_homework
        retrieve
        permitted = params.permit(:homework_id, :student_id)
        deliver_homework = DeliverHomework.find_by(student_id: permitted[:student_id].to_i, homework_id: permitted[:homework_id].to_i)
        deliver_homework.destroy!
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
        if @admin.nil? and @teaching_assistant.nil?
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
