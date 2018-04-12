Rails.application.routes.draw do
  devise_for :users
  
  devise_scope :user do
    authenticated do
      root to: 'pages#app'
    end

    unauthenticated do
      root to: 'devise/sessions#new'
    end
  end
  
  namespace :api, defaults: { format: :json } do
    resources :keyword_scrapes, only: [:index] do
      member do
        get 'download'
      end
    end
  end
end
