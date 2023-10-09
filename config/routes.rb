ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :collection => { :list => :get }, :member => { :settings => :get } do |projects|
    #projects.resources :reqs, :collection => { :list => :get }
    projects.resources :high_level_reqs, :collection => { :list => :get, :link_list => :get }
    projects.resources :functional_reqs, :collection => { :list => :get, :link_list => :get }
    projects.resources :non_functional_reqs, :collection => { :list => :get, :link_list => :get }
    projects.resources :business_reqs, :collection => { :list => :get, :link_list => :get }
    projects.resources :use_cases, :collection => { :list => :get, :link_list => :get }
    projects.resources :rules, :collection => { :list => :get, :link_list => :get }

    projects.resources :components, :collection => { :list => :get, :link_list => :get }
    projects.resources :functional_areas, :collection => { :list => :get }
    projects.resources :solutions, :collection => { :list => :get }
    projects.resources :stages, :collection => { :list => :get }

    projects.resources :graphs, :only => [:show]
  end

  map.resource :account, :member => { :status_form => :get, :user_list => :get }

  map.resources :teams, :collection => { :list => :get }
  map.resources :business_units, :collection => { :list => :get }

  if Rails.env.development?
    map.connect "/tests", :controller => "js_tests", :action => "index"
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Hack for Devise; see MyRegistrationsController for more info
  # this has to appear before map.devise_for
  map.connect '/users', :controller => 'registrations', :action => 'index',  :conditions => { :method => :get }
  map.connect '/users/admin_update', :controller => 'registrations', :action => 'admin_update',  :conditions => { :method => :put }
  
  map.devise_for :users


  map.root :controller => "projects"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
