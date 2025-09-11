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
