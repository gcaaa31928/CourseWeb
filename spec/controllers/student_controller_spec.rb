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
end
