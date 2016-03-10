require 'http_status_code'
class Api::StudentController < ApplicationController

    # deprecated
    def login
        permitted = params.permit(:id, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        student = Student.find(permitted[:id])
        if student.nil?
            return render HttpStatusCode.forbidden(
                {
                    errorMsg: 'id or password is not correct'
                })
        end
        if student.password == permitted[:password]
            token = student.generate_token_and_update
            return render HttpStatusCode.ok(
                {
                    accessToken: token
                })
        end
        render HttpStatusCode.forbidden(
            {
                errorMsg: 'id or password is not correct'
            })
    end

    def my_info
        retrieve
        student_json = @student.as_json(
            include: {
                deliver_homeworks: {
                    only: [:id, :homework_id]
                }
            }, only: [:id, :name]
        )
        roll_calls = RollCall.includes(:student).where(students: {id: @student.id})
        roll_calls.order!(date: :asc, period: :asc)
        student_json['roll_calls'] = []
        roll_calls.each do |roll_call|
            if roll_call.student.id == student_json['id']
                student_json['roll_calls'] << roll_call
            end
        end

        render HttpStatusCode.ok(student_json)
    end

    def list_without_group
        retrieve
        permitted = params.permit(:course_id)
        if @student and not same_course?(permitted[:course_id].to_i)
            raise '你沒有權限執行這個操作'
        end
        students = Student.where(group_id: nil)
        students.order!(:id)
        render HttpStatusCode.ok(students.as_json(only: [:id, :name]))
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
        if @student and not same_course?(permitted[:course_id].to_i)
            raise '你沒有權限執行這個操作'
        end

        students = Student.where(course_id: permitted[:course_id].to_i)
        students_json = students.as_json(
            include: {
                deliver_homeworks: {
                    only: [:id, :homework_id]
                }
            }, only: [:id, :name]
        )

        if permitted[:date]
            date = DateTime.rfc2822(permitted[:date])
            roll_calls = RollCall.includes(:student).where(date: date, students: {course_id: permitted[:course_id].to_i})
        else
            roll_calls = RollCall.includes(:student).where(students: {course_id: permitted[:course_id].to_i})

        end
        students_json.each do |student_json|
            student_json['roll_calls'] = []
            roll_calls.each do |roll_call|
                if roll_call.student.id == student_json['id']
                    student_json['roll_calls'] << roll_call
                end
            end
        end

        render HttpStatusCode.ok(students_json)
    end


    private


    def same_course?(course_id)
        @student.course_id == course_id
    end

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
