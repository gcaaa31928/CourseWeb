require 'rails_helper'

RSpec.describe Api::TimelogController, type: :controller do
    describe 'All' do
        it 'success' do
            create(:student_with_group)
            create(:student_with_group_second)
            create(:project)
            create(:group_with_project)
            create(:timelog)
            create(:time_cost)
            get :all, {project_id: 1}
            Log.debug(response.body)
            expect(response.status).to eq(200)
            # expect(data).to eq({'status' => 200, 'data' => [{'id' => 1, 'name' => "我是專案", 'group' => {'id' => 4}}]})
        end
    end

    describe 'Edit' do
        it 'success' do
            student = create(:student_with_group)
            create(:student_with_group_second)
            create(:project)
            create(:group_with_project)
            create(:timelog)
            create(:time_cost)
            request.headers['AUTHORIZATION'] = student.access_token
            get :edit, {timelog_id: 1, cost: 12, todo: 'good test'}
            Log.debug(response.body)
            expect(response.status).to eq(200)
            # expect(data).to eq({'status' => 200, 'data' => [{'id' => 1, 'name' => "我是專案", 'group' => {'id' => 4}}]})
        end
    end
end
