require 'resque/server'

TasteOCodeWeb::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match '/users/auth/:provider/callback' => 'omniauth#callback'
  match '/check_submissions' => 'tasks#check_submissions'
  match '/get_submission_source' => 'tasks#get_submission_source'
  devise_for :users, :controllers => { :sessions => :sessions }

  root :to => "home#show"

  resources :users, :only => [:index, :show, :edit, :update]

  resources :languages, :only => [:show] do
    post 'buy', :on => :collection
    resources :tasks, :only => [:show] do
      post 'submit', :on => :member
      get 'submissions', :on => :member
    end
  end

  resource :settings, :only => [:show, :update]

  match '/home', :to => 'home#show', :as => :home
  match '/greeting', :to => 'home#greeting', :as => :greeting
  match '/about', :to => 'about#show', :as => :about

  admin_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.class == AdminUser
  end

  constraints admin_constraint do
    mount Resque::Server, :at => "/admin/resque"
  end

end
