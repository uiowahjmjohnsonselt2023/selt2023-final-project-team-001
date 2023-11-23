Rails.application.routes.draw do
  get "home/index"
  get "pages/index"

  resources :products

  get "/signup", to: "users#new", as: "signup"
  post "/signup", to: "users#create", as: "signup_submit"

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

  # Defines routes for our custom error pages.
  # to: "controller#action" specifies the controller and action.
  # via: :all uses the same route for all HTTP methods (GET, POST, etc).
  match "/404", to: "errors#not_found", via: :all, as: :not_found
  match "/500", to: "errors#internal_server_error", via: :all, as: :internal_server_error
end
