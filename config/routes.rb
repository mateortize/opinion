Rails.application.routes.draw do
  devise_for :accounts, :controllers => { registrations: 'registrations' }

  get '/auth/:provider/callback', to: 'omniauth#create'
  post '/auth/:provider/callback', to: 'omniauth#create'
  get '/auth/failure', to: redirect('/')

  namespace :account do
    resources :surveys do
      get :export, on: :member
      get :statistics, on: :member
      put :publish, on: :member
      put :unpublish, on: :member

      resources :questions do
        get :sort, on: :member
        get :answers, on: :member
        get :children, on: :member

        resources :answers
        resources :questions, controller: 'question_children'
      end
    end

    resource :plan, only: [:show]
    resources :subscriptions
    resource :profile
  end

  resources :plans, only: [:index]
  resources :surveys do
    post :submit, on: :member
    get :preview, on: :member
    get :embedded_script, on: :member
    get :embedded_html, on: :member
  end

  resources :answers
  resources :questions

  resources :pages, only: [] do
    get :impress, on: :collection
    get :termsofuse, on: :collection
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :packages do
      resources :limitations
    end
    resources :plans
    resources :accounts do
      collection do
        get :autocomplete
      end
    end
    resources :videos
    resources :subscriptions, only: [:index, :destroy]
    resources :contact_messages, only: [:index, :destroy]
  end

  get '/account', to: 'account/surveys#index', as: 'account_root'
  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'

  devise_scope :account do
    get '/p/:referrer_code', to: 'registrations#promolink', as: 'promolink'
  end

  root to: 'account/surveys#index'

end
