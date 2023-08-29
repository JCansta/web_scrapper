require_relative '../../helpers/http_client_helper'
module Schedules
    class ScheduleInterface
      def perform!
        raise "Method not implemented"
      end
      def request_data
        raise "Method not implemented"
      end
      def construct
        raise "Method not implemented"
      end
    end
end
  