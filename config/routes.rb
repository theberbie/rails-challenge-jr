Rails.application.routes.draw do
  root 'messages#new'
  resources :messages, only: [:create, :new]
  get 'messages/:token' => 'messages#show', as: :show_message
  get 'messages/auth/:auth' => 'messages#view_message', as: :view_message
  get 'messages/:auth/authenticate_viewer' => 'messages#authenticate_viewer', as: :authenticate_viewer
  post 'messages/:auth/viewer_authenticated' => 'messages#viewer_authenticated', as: :viewer_authenticated
  patch 'messages/:token/add_url' => 'messages#add_url', as: :add_url
  get 'messages/secure_message/:auth' => 'messages#view_secure_message', as: :view_secure_message
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
