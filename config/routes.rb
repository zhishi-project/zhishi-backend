require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
    scope '/:resource_name/:resource_id', constraints: { resource_name: /(questions|answers|comments)/ } do
      post '/upvote', to: 'votes#upvote'
      post '/downvote', to: 'votes#downvote'
      resources :comments, except: [:new, :edit], resource_name: /(?!comments).*/
    end

    get :notifications, to: 'users#notifications'
    get :point_notifications, to: 'users#point_notifications'

    resources :questions, except: [:new, :edit] do
      collection do
        get :search
        get :personalized
        get :all
        get :by_tags
      end
      member do
        get "recent_answers"
        get "popular_answers"
      end

      resources :answers, except: [:new, :edit] do
        member do
          post "accept"
        end
      end
    end

    get "top_questions" => "questions#top_questions"
    get 'users/me', to: 'users#me', as: :me
    resources :users, only: [:show, :index] do
      member do
        get :questions
        get :tags
        get :activities
      end
    end

    resources :tags, only: [:index] do
      collection do
        get :popular
        get :recent
        get :trending
        get :subscribable
        post :update_subscription
      end
    end

    get "logout" => "application#logout"

    mount Sidekiq::Web => '/sidekiq'

    match "*path", to: 'application#resource_not_found', via: :all
end
