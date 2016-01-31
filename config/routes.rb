Rails.application.routes.draw do
    root :to => 'view#index'
    namespace :api do
        post 'login' => 'login#login'
        post 'verify_access_token' => 'login#verify_access_token'

        post 'create_group' => 'group#create'
        post 'create_course_students' => 'admin#create_course_students'

        get 'course/:course_id/students/list_without_group' => 'student#list_without_group'

        post 'group/create' => 'group#create'
        post 'group/destroy' => 'group#destroy'
        get 'group/show' => 'group#show'
        get 'course/:course_id/group/all' => 'group#all'

        post 'project/create' => 'project#create'
        post 'project/destroy' => 'project#destroy'
        post 'project/edit' => 'project#edit'
        get 'project/all' => 'project#all'
        get 'project/show' => 'project#show'

        get 'project/:project_id/timelog/all' => 'timelog#all'
        post 'timelog/:timelog_id/edit' => 'timelog#edit'

        get 'course/all' => 'course#all'
    end
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    # root 'welcome#index'

    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end

    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
end
