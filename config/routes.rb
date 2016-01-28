Rails.application.routes.draw do
  resources :questions, except: [:new, :edit] do
    get "recent_answers"
    get "popular_answers"
    resources :comments, except: [:new, :edit]
    resources :answers, except: [:new, :edit]
  end
  get "questions/top_questions" => "questions#top_questions"

  resources :answers, except: [:index, :show, :create, :destroy, :update, :new, :edit] do
    resources :comments, except: [:new, :edit]
  end

  resources :comments, only: [:update, :delete]

  post "users" => "users#authenticate"
  post "users/logout" => "user#logout"
  get "users" => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/questions" => "users#questions"
  get "users/:id/tags" => "users#tags"

  get "tags" => "tags#index"
  get "tags/popular" => "tags#popular"
  get "tags/recent" => "tags#recent"
  get "tags/trending" => "tags#trending"
end
