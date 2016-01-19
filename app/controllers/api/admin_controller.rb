
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

    def get_course_students
        @access_token = request.headers['AUTHORIZATION']
        unless verify_access_token
            return render HttpStatusCode.forbidden
        end
        students_id_list, students_name_list = NTUTCourse.login_to_nportal('104598037', 'qwerasdf40144', '209065')
        students_id_list.zip(students_name_list).each do |id, name|
            student = Student.new(name: name, id: id.to_i)
            student.password = id
            student.save!
        end
        render HttpStatusCode.ok
    end

    private

    def verify_access_token
        admin = Admin.find(0)
        if @access_token == admin.access_token
            return true
        end
        false
    end


    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end

end
