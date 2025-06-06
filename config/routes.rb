Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
    get "users", to: "users/sessions#index"
    get "users/me", to: "users/sessions#show"
  end

  resources :recipes do
    collection do
      get "generate_recipes", to: "recipes#generate_recipes"
    end
  end
  resources :ingredients
  resources :pantry_ingredients do
    collection do
      delete "", to: "pantry_ingredients#delete_ingredient_from_pantry"
    end
  end
  resources :pantries do
    collection do
      get "mypantry", to: "pantries#show"
    end
  end
  resource :favorites
  resources :carts do
    collection do
      get "mycart", to: "carts#show"
    end
  end
  resources :cart_ingredients do
    collection do
      delete "", to: "cart_ingredients#delete_ingredient_from_cart"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
