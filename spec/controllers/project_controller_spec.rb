require 'rails_helper'

RSpec.describe Api::ProjectController, type: :controller do
    describe 'Create' do
        it 'success' do
            student = create(:student_with_group)
            create(:group)
            request.headers['AUTHORIZATION'] = student.access_token
            post :create, {:name => '123'}
            expect(Project.first).not_to eq(nil)
            expect(response.status).to eq(200)
        end
    end

    describe 'All' do
        it 'success' do
            create(:student_with_group)
            create(:student_with_group_second)
            create(:project)
            create(:group_with_project)
            post :all
            data = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(data).to eq({'status' => 200, 'data' => [{'id' => 1, 'name' => "我是專案", 'group' => {'id' => 4}}]})
        end
    end

    describe 'Edit' do
        it 'success' do
            student = create(:student_with_group)
            create(:student_with_group_second)
            create(:project)
            create(:group_with_project)
            request.headers['AUTHORIZATION'] = student.access_token
            post :edit, {id: 1, name: 'abc'}
            project = Project.first
            expect(response.status).to eq(200)
            expect(project.name).to eq('abc')
        end
    end
end
