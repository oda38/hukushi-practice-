Rails.application.routes.draw do

#ゲストログイン 
  devise_scope :user do
    get 'user/guest_sign_in', to: 'publics/sessions#guest_sign_in'
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
  get '/announcements' => 'publics/homes#announcements'
  scope module: :publics do
    resources :users, only:[:index, :show, :edit, :update] do
      resources :posts, only:[:index]
      member do
        get :confirm
        get :favorites
      end
    end
    
    resources :posts, only:[:new, :create, :index, :show, :edit, :update, :destroy]do
       resources :comments, only: [:create, :destroy]
       resource :favorites, only: [:create, :destroy]
    end
    
    post "search" => "searches#search"
    get "search_tag"=>"posts#search_tag"
  end
  
  
  
#管理者側
  devise_for :admins, skip: [:registrations, :passwords], 
    controllers: {
    sessions: 'admins/sessions'
  }
  
  namespace :admins do
    patch "withdrawal/:id" => "users#withdrawal", as: "withdrawal"
    
    resources :users, only:[:index, :show]
    resources :announcements, only:[:index, :new, :create, :show, :edit, :update, :destroy]
    resources :posts, only:[:index, :show, :destroy]do
      resources :comments, only: [:destroy]
    end
  end
  
  
 
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
