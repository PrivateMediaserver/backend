Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://pm.big.wtf", "http://localhost:4173", "http://localhost:5173"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
