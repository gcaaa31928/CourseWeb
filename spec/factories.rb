require 'factory_girl'

FactoryGirl.define do  factory :chart do
    
  end
  factory :forgot_password_token do
    
  end


    factory :admin do
        access_token '0f2071f7d24348f29a4d8a0cf8cf6791'
        id 0
    end

    factory :student do
        id 104598037
        name '黃泓鳴'
        access_token 'i0J7DbObY2HSFpb5vZwG6PUw8w6RXpTqRgSacG'
        course_id 209065
    end

    factory :course do
        id 209065
    end

    factory :course_second, class: Course do
        id 209066
    end

    factory :student_second, class: Student do
        id 104598038
        access_token 'i0J7DbObY2HSFpb5vZwG6PUw8w6RXpTqRgSacG'
    end

    factory :student_with_group, class: Student do
        id 104598038
        name '黃泓鳴'
        access_token 'i0J7DbObY2HSFpb5vZwG6PUw8w6RXpTqRgSacG'
        group_id 4
        course_id 209065
    end

    factory :student_with_group_second, class: Student do
        id 104598039
        access_token 'i0J7DbObY2HSFpb5vZwG6PUw8w6RXpTqRgSacG'
        group_id 5
    end

    factory :group do
        id 4
        course_id 209065
    end

    factory :group_with_project, class: Group do
        id 4
    end

    factory :project do
        id 1
        group_id 4
        name '我是專案'
    end

    factory :timelog do
        id 1
        week_no 1
        project_id 1
        todo 'todo 1'
    end

    factory :time_cost do
        id [104598038, 1]
        cost 2
    end

end

