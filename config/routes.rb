Rails.application.routes.draw do
  get 'game', to: 'pages#game', at: :game

  get 'score', to: 'pages#score', at: :score

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
