Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies do
        collection do
          post '/cine_colombia', to: 'movies#scrape_cine_colombia'
          post '/royal_films', to: 'movies#scrape_royal_films'
        end
      end

      resources :openai
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
