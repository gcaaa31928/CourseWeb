require 'rails_helper'
require 'factory_girl'
RSpec.describe Api::AdminController, type: :controller do
    describe 'Login' do
        it 'success' do
            post :login, {:account => 'wkchen', :password => 'b29wY291cnNl'}
            expect(response.status).to eq(200)
        end

    end
    describe 'Create Course Student' do
        it 'failed' do
            attrs = create(:admin)
            request.headers['AUTHORIZATION'] = "1234"
            post :create_course_students
            expect(response.status).to eq(400)
        end
        it 'success' do
            attrs = create(:admin)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :create_course_students, {:course_id => 209065}
            expect(response.status).to eq(200)
            course = Course.first
            Log.debug(course.id.to_s)
            student = Student.find_by(id: 102590028)
            expect(course.name).to eq("物件導向程式設計實習\n")
            expect(student.course_id).to eq(course.id)
            expect(student.class_name).to eq("四資二\n\n")
        end
    end
end
