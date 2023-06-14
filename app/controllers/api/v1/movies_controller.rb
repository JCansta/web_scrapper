class Api::V1::MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :update, :destroy]

  # GET /movies
  def index
    render json: @movies
  end

  
  def scrape
    url = 'https://www.cinecolombia.com/barranquilla/peliculas/spider-man-a-traves-del-spiderverso'
    response = MoviesSpider.process(url)
    if response[:status] == :completed && response[:error].nil?
      render json: "Successfully scraped url"
    else
      render json: response[:error]
    end
    rescue StandardError => e
      render json: "Error: #{e}"
  end


end
