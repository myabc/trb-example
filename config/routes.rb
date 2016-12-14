Rails.application.routes.draw do
  concern :votable do
    member do
      put :upvote
      put :downvote
    end

    resources :votes, only: [:index, :show, :create, :update, :destroy]
  end

  concern :bookmarkable do
    member do
      put    :bookmark
      delete 'bookmark', action: :unbookmark
    end

    resources :bookmarks, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:index, :create, :destroy] do
      member do
        put :report
      end
      resources :replies, only: [:create]
    end
  end

  namespace :api, path: '(/api)/', defaults: { format: 'json' } do
    devise_for :users

    namespace :v1, shallow: true do
      resources :hospitals, only: [:index, :show] do
        resources :departments, only: [:index, :show, :create, :update, :destroy] do
          member do
          end
          resources :clinics, only: [:index, :show, :create, :update, :destroy] do
            resources :nurses, :doctors, only: [:index, :show, :create, :update, :destroy] do
              concerns [:votable, :bookmarkable, :commentable]
              member do
                put :report
              end
            end
          end
          resources :wards, only: [:index, :create, :destroy, :show] do
            concerns [:bookmarkable]
            member do
              put :report
              put :upvote
            end
          end
        end
      end

      resources :users, only: [:show]
    end
  end
end
