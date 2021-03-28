Qrp::Application.routes.draw do
root 'static_pages#home'
  get "password_resets/new"
  get "password_resets/edit"
  get "password_reset/new"
  get "password_reset/edit"

get '/goqrp' => redirect("https://www.qsl.net/n/nzqrpers/gqn/")
match '/about',   to: 'static_pages#about',   via: 'get'
resources :sessions, only: [:new, :create, :destroy]
match "/users/editgrid", :to => "users#editgrid", :via => "get"
match "/users/data", :to => "users#data", :as => "user_data", :via => "get"
match "/users/db_action", :to => "users#db_action", :as => "user_db_action", :via => "get"
resources :users
 get 'users/:id/add', to: 'users#add'
 get 'users/:id/delete', to: 'users#delete'

resources :topics
resources :qrpnzmembers
resources :hota
 get 'hota/:id/delete', to: 'hota#delete'
resources :posts
 get 'posts/:id/delete', to: 'posts#delete'
resources :images
 get 'images/:id/delete', to: 'images#delete'
resources :files
 get 'files/:id/delete', to: 'files#delete'
resources :uploadedfiles, path: "files"
 get 'uploadedfiles/:id/delete', to: 'files#delete'

  match '/sessions', to: 'static_pages#home',    via:'get'
  match '/queries/hut', to: 'queries#hut',    via:'get'
  match '/queries/park', to: 'queries#park',    via:'get'
  match '/queries/island', to: 'queries#island',    via:'get'
  match '/queries/summit', to: 'queries#summit',    via:'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signup',  to: 'users#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  resources :password_resets, only: [:new, :create, :edit, :update]

match "/contest_logs/:id/save", :to => "contest_logs#save", :as => "contest_log_save_data", :via => "post"
match "/contest_logs/:id/load", :to => "contest_logs#load", :as => "contest_log_load_data", :via => "get"
resources :contest_logs
 get 'contest_logs/:id/delete', to: 'contest_logs#delete'
resources :uploads
resources :contest_series
resources :contests


end

