Rails.application.routes.draw do
  get '/search' => 'search#search'
  resources :posts do
  resources :comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
  end
  root 'posts#index'
  devise_for :users,
  controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
 # バリデーション後usersアドレスに飛ばないように変更
  devise_scope :user do
    post 'users/sign_up', to: 'users/registrations#create'
    patch 'users/edit', to: 'users/registrations#update'
    put 'users/edit', to: 'users/registrations#update'
  end

  resources :users, only: [:show, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

 # 仮想環境で使用するメールボックス
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
