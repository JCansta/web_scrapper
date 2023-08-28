module Schedules
    class RoyalFilms < ScheduleInterface
        include ::Helpers::HttpClientHelper
        # THEATRE = "https://www.royal-films.com/pelicula/barranquilla/"
        # WEBSITE = "https://royal-films.com/api/v1/movies/city/barranquilla/billboard"

        class BodyChangedError < StandardError; end;

        def request_data
            current_date = Date.today
            formatted_date = current_date.strftime('%Y-%m-%d')
            body = fetch_data("https://royal-films.com/api/v1/movies/city/barranquilla/billboard")
            movies = body['data']
            billboard = movies.map do |movie|
                fetch_data("https://royal-films.com/api/v1/movie/#{movie['id']}/city/barranquilla/schedules/#{formatted_date}")
            end
            [movies, billboard]
        end

        def constructor(data)
            movies = data.first
            billboard = data.last
            all_movies = []
            billboard.each_with_index do |movie, index|
                movie['data'].each do |data|
                    theather_name = data['name']
                    data['schedules'].each do |time|
                        unless time.empty?
                            all_movies << {
                                theather_name: theather_name,
                                date_time: DateTime.parse(time['schedule']).in_time_zone('America/Bogota'),
                                title: movies[index]['title'],
                                movie_format: "#{time["format_movie"]['_format']['name']} - #{time["format_movie"]['_caption']['name']}",
                                image_url: movies[index]['poster_photo'],
                                description: movies[index]['synopsis'],
                                slug: get_slug(movies[index]),
                                url: get_url(movies[index]),
                                original_id: movies[index]['id'],
                            }
                        end
                    end
                end
            end
            all_movies
        end

        def save(schedules)
            ActiveRecord::Base.transaction do
                schedules.each do |movie|
                    Schedule.create(movie)
                end
            end
        end
        private

        def get_slug(movie)
            @slug ||= UnicodeUtils.nfkd(movie['title']).gsub(/[^\x00-\x7F]/,'').downcase.gsub(/[^a-zA-Z\s]/, '').gsub(/\s+/, '-')
        end

        def get_url(movie)
            'https://www.royal-films.com/pelicula/barranquilla/' + movie['id'].to_s + '/' + @slug
        end
    end
end