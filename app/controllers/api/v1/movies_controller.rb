class Api::V1::MoviesController < ApplicationController
   
  def scrape_cine_colombia
    url = 'https://www.cinecolombia.com/barranquilla/peliculas/flash'
    response = CineColombiaSpider.process(url)
    if response[:status] == :completed && response[:error].nil?
      @data = File.read("cine_colombia.json")
      render json: @data
    else
      render json: response[:error]
    end
    rescue StandardError => e
      render json: "Error: #{e}"
  end

  def scrape_royal_films
    url = 'https://www.royal-films.com/cartelera/barranquilla'
    response = RoyalFilmsSpider.process(url)
    if response[:status] == :completed && response[:error].nil?
      @data = File.read("royal.json")
      render json: @data
    else
      render json: response[:error]
    end
    rescue StandardError => e
      render json: "Error: #{e}"
  end


end
