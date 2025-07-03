Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # API v1 endpoints
    end
  end
end
