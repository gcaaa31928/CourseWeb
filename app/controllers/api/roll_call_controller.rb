class Api::RollCallController < ApplicationController

    def add
        retrieve
        permitted = params.permit(:period, :date, :student_id)
        date = DateTime.rfc2822(permitted[:date])
        if RollCall.find_by(period: permitted[:period],
                            date: date,
                            student_id: permitted[:student_id].to_i)
            raise '你已經為這個學生登記缺課'
        end
        RollCall.create(period: permitted[:period],
                        date: date,
                        student_id: permitted[:student_id].to_i)
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end


    def destroy
        retrieve
        permitted = params.permit(:period, :date, :student_id)
        date = DateTime.rfc2822(permitted[:date])
        roll_call = RollCall.find_by(period: permitted[:period],
                                     date: date,
                                     student_id: permitted[:student_id].to_i)
        roll_call.destroy!
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
        permitted = params.permit(:course_id, :date)
        date = DateTime.rfc2822(permitted[:date])
        roll_calls = RollCall.joins(:student).where(date: date, students: {course_id: permitted[:course_id].to_i})
        render HttpStatusCode.ok(roll_calls.as_json(
            include: {
                student: {
                    only: [:id, :name]
                }
            }, only: [:id, :period]
        ))
    end


    private

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin
        if @teaching_assistant.nil? and @admin.nil?
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
