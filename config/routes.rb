require 'resque/server'

TasteOCodeWeb::Application.routes.draw do

  ActiveAdmin.routes(self)

  match '/users/auth/:provider/callback', to: 'omniauth#callback'

  devise_for :users, controllers: { sessions: :sessions }
  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'home#show'

  resources :users, only: [:index, :show, :edit, :update]

  resources :languages, only: :show do
    post :buy, on: :collection

    resources :tasks, only: :show do
      member do
        post :submit
        get :submissions
      end
    end
  end

  resources :submissions, only: :index do
    get :source, on: :member
  end

  resource :settings, only: [:show, :update]

  match '/home',     to: 'home#show',     as: :home
  match '/greeting', to: 'home#greeting', as: :greeting
  match '/about',    to: 'about#show',    as: :about

  admin_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.class == AdminUser
  end

  constraints admin_constraint do
    mount Resque::Server, at: '/admin/resque'
  end

end
