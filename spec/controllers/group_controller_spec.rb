require 'rails_helper'

RSpec.describe Api::GroupController, type: :controller do
    describe 'Create' do
        it 'failed' do
            attrs = create(:student)
            create(:student_with_group)
            create(:group)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :create, {:student_id => 104598038}
            expect(response.status).to eq(400)
        end

        it 'failed' do
            attrs = create(:student)
            create(:student_second)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :create, {:student_id => 104598039}
            expect(response.status).to eq(400)
        end

        it 'success' do
            attrs = create(:student)
            create(:student_second)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :create, {:student_id => 104598038}
            expect(response.status).to eq(200)
            expect(Group.first).not_to eq(nil)
        end
    end

    describe 'Destroy' do
        it 'failed' do
            attrs = create(:student)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :destroy
            expect(response.status).to eq(400)
        end

        it 'success' do
            group = create(:group)
            attrs = create(:student_with_group)
            request.headers['AUTHORIZATION'] = attrs.access_token
            post :destroy
            expect(response.status).to eq(200)
        end
    end

    describe 'Show' do
        it 'success' do
            attrs = create(:student)
            request.headers['AUTHORIZATION'] = attrs.access_token
            get :show
            response_json = JSON.parse(response.body)
            expect(response_json['data']).to eq([])
            expect(response.status).to eq(200)
        end

        it 'success' do
            group = create(:group)
            attrs = create(:student_with_group)
            request.headers['AUTHORIZATION'] = attrs.access_token
            get :show
            response_json = JSON.parse(response.body)
            expect(response_json['data']).to eq([{'id' => 104598038, 'name' => nil}])
            expect(response.status).to eq(200)
        end
    end

    describe 'All' do
        it 'success' do
            create(:course)
            group = create(:group)
            attrs = create(:student_with_group)
            request.headers['AUTHORIZATION'] = attrs.access_token
            get :all, {course_id: 209065}
            response_json = JSON.parse(response.body)
            Log.info(response_json['data'].to_s)
            expect(response.status).to eq(200)
        end

    end
end
