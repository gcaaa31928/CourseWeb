require 'http_status_code'
require 'ntut_course'

class Api::AdminController < ApplicationController
    before_action :require_headers

    def login
        permitted = params.permit(:account, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        if permitted[:account] == 'wkchen' and permitted[:password] == 'oopcourse'
            admin = Admin.upsert
            render json: {
                access_token: admin.access_token,
                status: 200
            }, status: 200
        else
            render json: {
                error: 'Forbidden',
                status: 400
            }, status: 400

        end
    end

    def create_course_students
        retrieve

        permitted = params.permit(:course_id)
        course_name, class_name, academic_year, students_id_list, students_name_list = NTUTCourse.login_to_nportal('104598037', 'qwerasdf40144', permitted[:course_id])
        Student.transaction do
            course = Course.find_or_initialize_by(id: permitted[:course_id])
            course.update!(name: course_name, academic_year: academic_year)
            students_id_list.zip(students_name_list).each do |id, name|
                student = Student.find_or_initialize_by(id: id.to_i)
                student.name = name
                student.class_name = class_name
                student.course_id = course.id
                student.password = id
                student.save!
            end
        end
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def add_teaching_assistant
        retrieve
        permitted = params.permit(:id, :name, :class_name, :course_id)
        TeachingAssistant.create!(id: permitted[:id],
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
            @admin = Admin.find_by(access_token: @access_token)
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end

end
