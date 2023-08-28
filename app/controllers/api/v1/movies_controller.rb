class Api::V1::MoviesController < ApplicationController
  require 'unicode_utils'
  require 'active_support/time'

  def royal_films
    royal_films = Schedules::ScheduleFactory.for(:royal_films)
    movies = royal_films.request_data
    construct = royal_films.constructor(movies)
    save = royal_films.save(construct)

    render json: Schedule.all
  end

end
