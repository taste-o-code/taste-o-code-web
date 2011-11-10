TasteOCodeWeb::Application.routes.draw do

  match '/users/auth/:provider/callback' => 'omniauth#callback'
  devise_for :users, :controllers => { :sessions => :sessions }

  root :to => "home#show"

  resources :users, :only => [:index, :show, :edit, :update]

  resources :languages, :only => [:index, :show]

  resource :settings, :only => [:show, :update]

  match '/settings/change_password', :to => 'settings#change_password', :as => :change_password

  match '/home', :to => 'home#show', :as => :home

  match '/about', :to => 'about#show', :as => :about

end
