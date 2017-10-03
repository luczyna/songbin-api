Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # manage user details
  post 'user',   to: 'user#create'
  put 'user',    to: 'user#update'
  delete 'user', to: 'user#delete'

  # login
  post 'authenticate', to: 'authentication#authenticate'
end
