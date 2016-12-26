Rails.application.routes.draw do
  get '/selected_data', to: 'users#show_selected', as: 'selected_data'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
