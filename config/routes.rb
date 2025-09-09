Rails.application.routes.draw do
  # ログイン画面をトップに設定
  root "sessions#new"
  # ログイン後のトップ画面
  get "top", to: "home#index", as: "top"
  # 文章タグ、語彙タグ追加編集へのリンクページ
  get "/tags", to: "tags#index"
  # ユーザー登録
  resources :users, only: [ :new, :create, :create ]
  # 語彙
  resources :vocabularies, only: [ :new, :create, :index, :update, :destroy, :show ]
  # 文章
  resources :sentences, only: [ :new, :create, :index, :update, :destroy, :show ]
  # 文章タグ
  resources :sentence_tags, only: %i[index new create update destroy]
  # ログイン/ログアウト
  resource :session, only: [ :new, :create, :destroy ]
  # カレンダーに日毎の登録数を表示するダッシュボード
  resource :dashboard, only: [ :show ]
end
