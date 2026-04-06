Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post   '/auth/register', to: 'auth#register'
      post   '/auth/login',    to: 'auth#login'
      post   '/auth/refresh',  to: 'auth#refresh'
      delete '/auth/logout',   to: 'auth#logout'
      resources :items do
        collection { get :search }
        member { post :publish; post :archive }
      end
      resources :users, only: [:index, :show, :update, :destroy]
      resources :notifications, only: [:index, :show] do
        member { patch :mark_read }
        collection { patch :mark_all_read }
      end
    end
  end
  get '/health', to: proc { [200, {}, [{ status: 'ok' }.to_json]] }
end
