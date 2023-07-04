class Api::V1::MoviesController < ApplicationController
  require 'unicode_utils'
  require 'active_support/time'

  # def cine_colombia
  #   url = 'https://www.cinecolombia.com/barranquilla/peliculas/flash'
  #   response = CineColombiaSpider.process(url)
  #   if response[:status] == :completed && response[:error].nil?
  #     @data = File.read("cine_colombia.json")
  #     render json: @data
  #   else
  #     render json: response[:error]
  #   end
  #   rescue StandardError => e
  #     render json: "Error: #{e}"
  # end

  def royal_films
    billboard = royal_films_billboard
    schedule = royal_films_schedule(billboard)

    render json: Schedule.all
  end

  private

  def royal_films_billboard
    website = 'https://royal-films.com/api/v1/movies/city/barranquilla/billboard'
    theatre = 'https://www.royal-films.com/pelicula/barranquilla/'
    body = body_request(website)
    data = body['data']

    data.map do |movie|
      slug = UnicodeUtils.nfkd(movie['title']).gsub(/[^\x00-\x7F]/,'').downcase.gsub(/[^a-zA-Z\s]/, '').gsub(/\s+/, '-')
      url = theatre + movie['id'].to_s + '/' + slug
      {:title => movie['title'], :slug => slug, :url => url,:image_url => movie['poster_photo'], :description => movie['synopsis'], :original_id => movie['id']}
    end
  end

  def royal_films_schedule(billboard)
    current_date = Date.today
    formatted_date = current_date.strftime('%Y-%m-%d')
    ActiveRecord::Base.transaction do
      billboard.each do |movie|
        website = "https://royal-films.com/api/v1/movie/#{movie[:original_id]}/city/barranquilla/schedules/#{formatted_date}"
        body = body_request(website)
        datas = body['data']
        datas.each do |data|
          theather_name = data['name']
          data['schedules'].each do |time|
            next if time.nil?
            date_time = DateTime.parse(time['schedule']).in_time_zone('America/Bogota')
            movie_format = "#{time["format_movie"]['_format']['name']} - #{time["format_movie"]['_caption']['name']}"
            schedule = movie.merge({:theather_name => theather_name, :date_time => date_time, :movie_format => movie_format})
            @premiere = Schedule.new(schedule)
            @premiere.save
            rescue StandardError => e
              render json: "Error: #{e}"
          end
        end
      end
    end
  end

  def body_request(website)
    url = URI.parse(website)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  
    request = Net::HTTP::Get.new(url.request_uri)
    request['Authorization'] = 'Bearer your_access_token'
  
    response = http.request(request)
  
    body = JSON.parse(response.body)
  end


end
