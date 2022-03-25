Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources 'users', except: %i[destroy create edit show update index] do
        get 'send_transaction' => 'user#create_transaction'
        get 'check_balance' => 'user#balance'
      end
      resources :companies, except: [:destroy] do
        get 'check_balance' => 'company#balance'
        get 'send_transaction' => 'company#create_transaction'
        resources :contributions, except: [:destroy] do
          resources :replies, except: [:destroy, :show, :edit]
          get 'user_contributions' => 'companies#index_user_contributions'
          get 'check_balance' => 'contribution#balance'
          get 'add_user' => 'contribution#add_user_to_contribution'
          get 'vote' => 'contribution#vote_on_value'
          get 'start_work' => 'contribution#accept_start_work_contribution'
          get 'merge_request' => 'contribution#accept_finished_contribution'
        end
      end
      get 'user_companies' => 'companies#index_user_companies'
    end
  end
end
