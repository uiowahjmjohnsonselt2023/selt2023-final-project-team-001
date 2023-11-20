Rails.application.routes.draw do
  get "home/index"
  get "pages/index"

  resources :products

  get "/signup", to: "users#new", as: "signup"
  post "/signup", to: "users#create", as: "signup_submit"
  get "/checkout", to: "checkouts#index", as: "checkout"

  resources :profiles, only: [:show, :new, :create, :edit, :update], param: :id do
    get :delete, on: :member
    delete :destroy, on: :member
  end

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create", as: "login_submit"
  get "/logout", to: "sessions#destroy", as: "logout"
  get "/register", to: "sessions#register", as: "register"
  post "/register", to: "sessions#new_seller", as: "seller"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"
end
