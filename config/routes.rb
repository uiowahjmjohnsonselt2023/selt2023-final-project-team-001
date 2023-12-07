Rails.application.routes.draw do
  # get "price_alerts/send_price_alert"
  get "home/index"
  get "pages/index"

  resources :products

  get "/storefronts/preview", to: "storefronts#preview" # has to be before next line
  resources :storefronts, except: [:destroy] do
    get :choose_template, on: :member
    get :customize, on: :member
  end

  resources :price_alerts, only: [:new, :create, :index, :edit, :update], param: :id do
    get :delete, on: :member
    delete :destroy, on: :member
  end

  get "/send_price_alert", to: "price_alerts#send_price_alert", as: "send_price_alert"

  get "/signup", to: "users#new", as: "signup"
  post "/signup", to: "users#create", as: "signup_submit"
  get "/register", to: "users#register", as: "register"
  post "/register", to: "users#new_seller", as: "seller"

  post "/add_to_cart", to: "carts#add_to_cart", as: "add_to_cart"

  get "/checkout", to: "checkouts#index", as: "checkout"
  post "/update_quantity", to: "checkouts#update_quantity", as: "update_quantity"
  delete "/remove_item", to: "checkouts#remove_from_cart", as: "remove_item"
  post "/pay", to: "checkouts#update_product_inventory", as: "update_product_inventory"
  get "/forgot_password", to: "forgot_password#new", as: "forgot_password"
  post "/forgot_password_send_link", to: "forgot_password#send_link", as: "forgot_password_submit"
  get "/forgot_password_reset_password", to: "forgot_password#edit", as: "forgot_password_reset"
  post "/forgot_password_reset_password_submit", to: "forgot_password#update", as: "forgot_password_reset_submit"
  get "/review", to: "reviews#new", as: "review"
  post "/create_review", to: "reviews#create", as: "create_review"
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/send_message", to: "messages#new", as: "send_message"
  post "/send_message_submit", to: "messages#create", as: "send_message_submit"
  get "/view_messages", to: "messages#inbox", as: "view_messages"
  get "/view_sent_messages", to: "messages#sent", as: "view_sent_messages"
  get "/show_message", to: "messages#show", as: "message_details"
  get "/reply", to: "messages#reply", as: "reply"
  post "/send_reply", to: "messages#create_reply", as: "send_reply"
  delete "/delete_message", to: "messages#delete", as: "delete_message"

  get "/history", to: "products#history", as: "products_history"

  resources :profiles, only: [:show, :new, :create, :edit, :update], param: :id do
    get :delete, on: :member
    delete :destroy, on: :member
  end

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create", as: "login_submit"
  get "/logout", to: "sessions#destroy", as: "logout"
  get "/shop", to: "products#index", as: "shop"

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
