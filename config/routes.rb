Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
  
  devise_scope :user do
    root "devise/sessions#new", as: :unauthenticated_root
  end
  # ログイン後のトップ画面
  get "top", to: "home#index", as: "top"
  # 文章タグ/語彙タグ追加編集へのリンクページ
  get "/tags", to: "tags#index"
  # 語彙
  resources :vocabularies, only: [ :new, :create, :index, :update, :destroy, :show ]
  # 文章
  resources :sentences, only: [ :new, :create, :index, :update, :destroy, :show ]
  # 文章タグ/語彙タグ
  resources :sentence_tags, only: %i[index new create update destroy]
  resources :vocabulary_tags, only: %i[index new create update destroy]
  # bookmark
  resources :bookmarks, only: [:index, :create, :destroy]
  # カレンダーに日毎の登録数を表示するダッシュボード
  resource :dashboard, only: [ :show ]
  # letter_opener
  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
