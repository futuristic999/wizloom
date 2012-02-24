Wizloom::Application.routes.draw do

  get "entries/add"

  get "entries/show"

  get "templated_entries/add"

  get "templated_entries/show"

  get "templated_entries/delete"

  get "templated_entries/edit"


  match "entries"           => "entries#index"
  match "entries/save"      => "entries#save"
  match "entries/get/:id"   => "entries#get"
  match "entries/list"      => "entries#list"
  match "entries/delete/:id"    => "entries#delete"

  match  "templates.json/get/:id" => "templates#get"
  match  "templates/get/:id"    => "templates#get"
  match  "templates/delete/:id" => "templates#delete"
  match  "templates/edit/:id"   => "templates#edit" 
  match  "templates/list"   => "templates#list"
  match  "templates/add"    => "templates#add"
  match  "templates/save"   => "templates#save"
  match  "templates/:name"  => "templates#show"
  match  "templates"        => "templates#index"



  get "pages/home"

  get "pages/contact"
  
  get "pages/about"

  match "/" => "pages#home"

  resources :weight_entries

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
