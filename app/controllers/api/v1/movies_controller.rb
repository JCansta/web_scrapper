class Api::V1::MoviesController < ApplicationController
  require 'unicode_utils'
  require 'active_support/time'

  def royal_films
    scheduleImporter = Schedules::ScheduleFactory.for(:royal_films)
    scheduleImporter.perform!

    render json: Schedule.all
  end

end
