Rails.application.routes.draw do
  root 'boards#show'

  unless ARGV.include?('assets:precompile')
    devise_for :users, controllers: { sessions: 'users/sessions' }
  end

  resources :admin, only: :index

  resources :boards, shallow: true do
    resources :board_goals, only: [:create, :destroy, :update]
    resources :board_memberships, only: [:create, :destroy]
    resources :daily_notes, only: :index
    resources :tasks do
      resources :task_notes, only: [:create, :destroy]
    end
  end

  resources :users, shallow: true, only: [:show, :update, :destroy, :index] do
    resources :tasks, only: :index
    resources :daily_notes
    resources :boards
    resources :user_statuses, only: [:create, :destroy]
    resources :completed_tickets, only: [:create]
  end

end
