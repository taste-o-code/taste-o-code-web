TasteOCodeWeb::Application.routes.draw do

  match '/users/auth/:provider/callback' => 'omniauth#callback'
  match '/check_submissions' => 'tasks#check_submissions'
  devise_for :users, :controllers => { :sessions => :sessions }

  root :to => "home#show"

  resources :users, :only => [:index, :show, :edit, :update]

  resources :languages, :only => [:index, :show] do
    post 'buy', :on => :collection
    resources :tasks do
      post 'submit', :on => :member
    end
  end

  resource :settings, :only => [:show, :update]

  match '/home', :to => 'home#show', :as => :home

  match '/about', :to => 'about#show', :as => :about


end
