Rails.application.routes.draw do
 
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
 
 
 
#ユーザー側
  devise_for :users, skip: [:passwords], controllers: {
    sessions:      'publics/sessions',
    registrations: 'publics/registrations'
  }
  
  #退会確認画面
  get '/users/:id/unsubscribe' => 'publics/users#unsubscribe', as: 'unsubscribe'
  #論理削除用のルーティング
  patch '/users/:id/withdrawal' => 'publics/users#withdrawal', as: 'withdrawal'

  root to: 'publics/homes#top'
  scope module: :publics do
    resources :users, only:[:index, :show, :edit, :update] do
      resources :posts, only:[:index, :show, :edit]
      member do
        get :confirm
      end
    end
    
    resources :posts, only:[:new, :create, :index, :show, :edit, :update, :destroy]
  end
  
  
  
#管理者側
  devise_for :admins, skip: [:registrations, :passwords], 
    controllers: {
    sessions: 'admins/sessions'
  }
  
  namespace :admins do
    resources :users, only:[:index, :show, :create, :edit, :update]
    resources :announcements, only:[:index, :new, :create, :show, :edit, :update]
  end
  
  
 
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
