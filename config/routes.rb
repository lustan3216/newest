Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations'}

  root to: 'websites#index'
  resources :websites do
    scope module: :websites do
      collection do
        resources :patterns, only: [:index]
      end
      resource :current_episode, only: [:update]
    end
  end
end
