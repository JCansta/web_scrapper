module Schedules
    class RoyalFilms < ScheduleInterface
        include ::Helpers::HttpClientHelper
        THEATRE = "https://www.royal-films.com/pelicula/barranquilla/"
        WEBSITE = "https://royal-films.com/api/v1/movies/city/barranquilla/billboard"

        class BodyChangedError < StandardError; end;

        def construct
            p fetch_data
        end
    end
end 