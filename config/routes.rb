Rails.application.routes.draw do
  # Devise: disable registrations edit/update, keep sign up (new/create)
  devise_for :users, skip: [:registrations]
  as :user do
    get  'users/sign_up', to: 'devise/registrations#new',    as: :new_user_registration
    post 'users',         to: 'devise/registrations#create', as: :user_registration
  end

  # ユーザー詳細（自分用）
  resource :user, only: [:show, :update]

  # ログイン状態別 root
  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

  # 既存のページ
  get 'top', to: 'home#index', as: 'top'
  get '/tags', to: 'tags#index'

  # 語彙/文章
  resources :vocabularies, only: [:new, :create, :index, :update, :destroy, :show]
  resources :sentences,    only: [:new, :create, :index, :update, :destroy, :show]

  # タグ
  resources :sentence_tags,   only: %i[index new create update destroy]
  resources :vocabulary_tags, only: %i[index new create update destroy]

  # お気に入り
  resources :bookmarks, only: [:index, :create, :destroy]

  # ダッシュボード
  resource :dashboard, only: [:show]

  # letter_opener (dev only)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
