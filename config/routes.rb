require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  secure_username = ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"]))
  secure_password = ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  secure_username & secure_password
end if Rails.env.production?

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  mount Sidekiq::Web => "/sidekiq"

  scope defaults: { format: :json } do
    namespace :v1 do
      controller :authentications do
        get "authentications", action: :index
        post "authentications/refresh", action: :refresh
        delete "authentications/sign-out", action: :destroy
        delete "authentications/:id", action: :terminate
      end

      controller :authentications_base do
        post "authentications/base", action: :create
      end

      controller :authentications_passkey do
        post "authentications/passkey/options", action: :options
        post "authentications/passkey", action: :create
      end

      controller :passkey do
        post "passkey/options", action: :options
        post "passkey", action: :create
      end

      controller :user do
        get "user", action: :show
      end

      controller :videos do
        get "videos", action: :index
        post "videos", action: :create
        get "videos/random_id", action: :random_id
        get "videos/:id", action: :show
        get "videos/:id/playlist", action: :playlist, as: :videos_video_playlist
        get "videos/:id/screenshots", action: :screenshots
        patch "videos/:id", action: :update
        put "videos/:id/preview", action: :update_preview
        put "videos/:id/progress", action: :update_progress
        delete "videos/:id", action: :destroy
      end

      controller :people do
        get "people", action: :index
        post "people", action: :create
        get "people/:id", action: :show
        patch "people/:id", action: :update
        delete "people/:id", action: :destroy
      end

      controller :tags do
        get "tags", action: :index
        post "tags", action: :create
        get "tags/:id", action: :show
        patch "tags/:id", action: :update
        delete "tags/:id", action: :destroy
      end
    end
  end
end
