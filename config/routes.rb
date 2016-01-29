Rails.application.routes.draw do
  post 'questions/:question_id/upvote' => "votes#upvote"
  post 'answers/:answer_id/upvote' => "votes#upvote"
  post 'comments/:comment_id/upvote' => "votes#upvote"
  post 'questions/:question_id/downvote' => "votes#downvote"
  post 'answers/:answer_id/downvote' => "votes#downvote"
  post 'comments/:comment_id/downvote' => "votes#downvote"

  # resources :questions, except: [:new, :edit] do
  #   get "recent_answers"
  #   get "popular_answers"
  #   resources :comments, except: [:new, :edit]
  #   resources :answers, except: [:new, :edit]
  # end
  # get "questions/top_questions" => "questions#top_questions"

  # resources :answers, except: [:index, :show, :create, :destroy, :update, :new, :edit] do
  #   resources :comments, except: [:new, :edit]
  # end

  # resources :comments, only: [:update, :delete]

  # post "users" => "users#authenticate"
  # post "users/logout" => "user#logout"
  # get "users" => "users#index"
  # get "users/:id" => "users#show"
  # get "users/:id/questions" => "users#questions"
  # get "users/:id/tags" => "users#tags"

  # get "tags" => "tags#index"
  # get "tags/popular" => "tags#popular"
  # get "tags/recent" => "tags#recent"
  # get "tags/trending" => "tags#trending"

  # get "questions/:id/answers/popular" => ""
  # post "questions/:id/answers/:id/upvote" => ""
  # post "questions/:id/answers/:id/downvote" => ""
  # put "answers/:id" => ""
  # patch "answers/:id" => ""
  # delete "answers/:id" => ""


  # put "questions/:id" => ""
  # patch "questions/:id" => ""
  # delete "questions/:id" => ""

  # get "questions/:id/answers" => ""
  # post "questions/:id/answers" => ""
  # get "questions/:id/answers/recent" => ""
  # get "answers/:id/comments" => ""
  # post "answers/:id/comments" => ""
  # get "answers/:id/comments/recent" => ""
  # get "answers/:id/comments/popular" => ""
  # post "answers/:id/comments/:id/upvote" => ""
  # post "answers/:id/comments/:id/downvote" => ""
  # put "comments/:id" => ""
  # patch "comments/:id" => ""
  # delete "comments/:id" => ""



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
