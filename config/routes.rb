Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope defaults: { format: :json } do
    namespace :v1 do
      controller :authentications do
        get "authentications", action: :index
        post "authentications", action: :create
        post "authentications/refresh", action: :refresh
        delete "authentications/sign-out", action: :destroy
        delete "authentications/:id", action: :terminate
      end

      controller :user do
        get "user", action: :show
      end
    end
  end
end
