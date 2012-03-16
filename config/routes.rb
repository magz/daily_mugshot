DailyMugshot::Application.routes.draw do


  resources :friendships

  resources :add_some_fieldsto_authusers

  resources :videos

  resources :feedbacks

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  
  match "full_upload_get_api_paths/:id" => "apis#full_upload_get_api_paths"
  match "apis/upload_with_id/:id" => "apis#upload_with_id"
  #user related routes
  match "my_mugshow" => "authusers#show_mine", :as => :my_mugshow 
  match "my_account" => "authusers#edit", :as => :my_account
  match 'new_pic' => 'mugshots#new', :as => :new_pic, :via => :get
  match "authuser/signup" => "authusers#signup", :as => :signup
  match "first_pic" => "mugshots#first_pic", :as => :first_pic 
  match "update_account" => "authusers#edit", :as => :update_account
  match "authuser/search" => "authusers#search", :as => :search
  match "search" => "authusers#search"
  match "browse" => "authusers#index", :as => :browse
  match "account/loginxml" => "iphone#loginxml"
  match "authusers/forgot_password" => "authusers#forgot_password", :as => :forgot_password
  
  match "authusers/submit_forgot_password" => "authusers#submit_forgot_password", :as => :password_submit_reset
  match "/toggle_privacy" => "authusers#update_privacy", :as => :toggle_privacy
  match "/mugshots/ajax_image_fetch" => "mugshots#ajax_image_fetch", :as => :ajax_image_fetch
  
  # match "iphone/forgot" => "authuser/submit_forgot_password"
  
  #main controller, mostly static page routes
  match "main/faq" => "main#faq", :as => :faq
  match "main/about" => "main#about", :as => :about
  #?? did i do that...?
  match "main/welcome" => "main#welcome", :as => :oauth_confirm
  match "main/publish" => "main#publish", :as => :publish
  match "main/get_reminder" => "main#get_reminder", :as => :get_reminder
  
  match "flipbook/start" => "flipbook#intro", :as => :flipbook_intro
  match "flipbook/new" => "flipbook#new"
  
  match "feedback/new" => "feedbacks#new", :as => :new_feedback
  
  match "main/browse" => "authusers#index"
  #sessions routes
  match "sessions/login" => "sessions#login", :as => :login
  match "sessions/logout" => "sessions#logout", :as => :logout
  
  #social networking routes
  match "publish/new" => "publish#new", as: :publish
  match "publish/twitter_callback" => "publish#twitter_callback", :as => :twitter_callback
  match "publish/facebook_callback" => "publish#facebook_callback", :as => :fb_callback
  
  
  #api routes
  #these are used primarily for the various flash objects
  #the api calls contained in here were originally separated into 2 controllers
  #but that's dumb, so now they're not...be careful with security though
  match "openapis/:action" => "apis##{:action}"
  match "apis/:action" => "apis##{:action}"
  match "/camera_hope" => "mugshots#first_pic"
  match "main/camera_hope" => "mugshots#first_pic"

  match "mugshots/ajax_active_update/" => "mugshots#ajax_active_update"
  #resources routes
  #be careful with these
  resources :authusers
  resources :twitter_connects
  resources :landmarks
  resources :comments
  resources :mugshots
  resources :email_reminders
  
  
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
  match "rss/:size/:login" => "rss#feed"
  match "secret" => "main#secret"
  match "martin_delete" => "main#martin_delete"
  match "iphone/forgot" => "authusers#forgot_password"
  match "iphone/signup" => "authusers#signup"
  match "main/show/:id" => "authusers#show"
  match "/:id" => "authusers#show"
  match "authuser/new_pic" => "mugshots#new"
  match "frienships/add_follow" => "friendships#add_follow"
  match "frienships/remove_follow" => "friendships#remove_follow"
  match "authusers/create_comment" => "authusers#create_comment"

  match '/auth/twitter/callback', to: 'twitter_connects#create'
  match '/auth/failure', to: 'twitter_connects#fail'
  match "/auth/signup_for_twittter" => "twitter_connects#signup_for_twittter", :as => "twitter_signup"
  match "/auth/deactivate_twitter" => "twitter_connects#deactivate_twitter", :as => "deactivate_twitter"

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'main#welcome'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
