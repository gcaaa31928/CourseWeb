require 'rails_helper'

RSpec.describe Api::LoginController, type: :controller do
    describe 'Login' do
        it 'success' do
            post :login, {:account => 'wkchen', :password => 'b29wY291cnNl'}
            expect(response.status).to eq(200)
        end

    end
end
