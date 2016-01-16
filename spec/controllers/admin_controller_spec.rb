require 'rails_helper'
require 'factory_girl'
RSpec.describe AdminController, type: :controller do
    describe 'Login' do
        it 'success' do
            post :login, {:account => 'wkchen', :password => 'b29wY291cnNl'}
            expect(response.status).to eq(200)
        end

    end
    describe 'Get Course Student' do
        it 'failed' do
            attrs = create(:admin)
            request.headers['AUTHORIZATION'] = "1234"
            post :get_course_students
            expect(response.status).to eq(400)
        end
        it 'success' do
            attrs = create(:admin)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :get_course_students
            expect(response.status).to eq(200)
        end
    end
end
