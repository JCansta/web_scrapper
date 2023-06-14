Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies do
        collection do
          post '/scrape', to: 'movies#scrape'
        end
      end
    end
  end

  root to: 'movies#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
