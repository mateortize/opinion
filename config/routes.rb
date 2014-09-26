Rails.application.routes.draw do
  devise_for :accounts

  get '/auth/:provider/callback', to: 'omniauth#create'
  post '/auth/:provider/callback', to: 'omniauth#create'
  get '/auth/failure', to: redirect('/')

  namespace :account do
    resources :surveys do
      get :export, on: :member
      get :metrics, on: :member
      put :publish, on: :member
      put :unpublish, on: :member

      resources :questions do
        get :sort, on: :member
        resources :answers
      end
    end

    resources :plans, only: [:index]
    resources :subscriptions
    
    get '/', to: 'surveys#index'
  end

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
  get '/admin', to: 'admin/dashboard#index', as: 'admin_root'

  root to: 'account/surveys#index'

end
