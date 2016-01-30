require 'rails_helper'
require 'factory_girl'
RSpec.describe Api::StudentController, type: :controller do
    describe 'Login' do
        it 'failed' do
            attrs = create(:student)
            post :login, {:id => '104598037', :password => '1234'}
            expect(response.status).to eq(400)
        end
    end

    describe 'List without group' do
        it 'success' do
            create(:course)
            attrs = create(:student)
            request.headers['AUTHORIZATION'] = attrs.access_token
            get :list_without_group, {course_id: 209065}
            response_json = JSON.parse(response.body)
            Log.info(response_json['data'].to_s)
            expect(response.status).to eq(200)
        end
        it 'failed' do
            create(:course)
            create(:course_second)
            attrs = create(:student)
            request.headers['AUTHORIZATION'] = attrs.access_token
            get :list_without_group, {course_id: 209066}
            expect(response.status).to eq(400)
        end
    end

end
