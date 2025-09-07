Rails.application.routes.draw do
  #ログイン画面をトップに設定
  root 'sessions#new'
  #ログイン後のトップ画面
  get 'top', to: 'home#index' , as: 'top'
  #ユーザー登録
  resources :users, only: [:new, :create,]
  #語彙
  resources :vocabularies, only: [:index, :new]
  #ログイン/ログアウト
  resource :session, only: [:new, :create, :destroy]
  #カレンダーに日毎の登録数を表示するダッシュボード
  resource :dashboard, only: [:show]

end
