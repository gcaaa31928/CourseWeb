require 'factory_girl'

FactoryGirl.define do  factory :time_cost do
    
  end


    factory :admin do
        access_token '0f2071f7d24348f29a4d8a0cf8cf6791'
        id 0
    end

    factory :student do
        id 104598037
        password_hash '$2a$10$Lx09Yyv/0yo4dfWi0J7DbObY2HSFpb5vZwG6PUw8w6RXpTqRgSacG'
    end

end

