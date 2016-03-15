require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  scope '/:resource_name/:resource_id', constraints: { resource_name: /(questions|answers|comments)/ } do
    post '/upvote', to: 'votes#upvote'
    post '/downvote', to: 'votes#downvote'
    resources :comments, except: [:new, :edit], resource_name: /(?!comments).*/
  end

  post '/validate_token', to: 'tokens#validate'

  resources :questions, except: [:new, :edit] do
    collection do
      get :search
    end
    member do
      get "recent_answers"
      get "popular_answers"
    end

    resources :answers, except: [:new, :edit] do
      member do
        get "accept"
      end
    end
  end

  get "top_questions" => "questions#top_questions"

  resources :users, only: [:show, :index] do
    member do
      get :questions
      get :tags
    end

    collection do
      post :logout
      get :renew_token
    end
  end

  resources :tags, only: [:index] do
    collection do
      get :popular
      get :recent
      get :trending
    end
  end

  get 'login', to: "users#login"
  get 'login/:provider', to: "users#login"

  get 'auth/:provider/callback', to: 'users#authenticate', as: :authenticate
  mount Sidekiq::Web => '/sidekiq'

  match "*path", to: 'application#resource_not_found', via: :all
end
