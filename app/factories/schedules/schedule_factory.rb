module Schedules
  class ScheduleFactory
    class << self
      AVAILABLE_THEATERS = {
        # cine_colombia: ::Schedules::CineColombia,
        royal_films: ::Schedules::RoyalFilms
        # cinepolis: ::Schedules::Cinepolis
      }

      def for(class_name)
        raise "Developer class not found" if !AVAILABLE_THEATERS.keys.include? class_name
        AVAILABLE_THEATERS[class_name].new
      end
    end
  end
end
  