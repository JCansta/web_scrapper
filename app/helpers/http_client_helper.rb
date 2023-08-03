module Helpers
    module HttpClientHelper
        def fetch_data
            url = URI.parse(self.class::WEBSITE)
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = (url.scheme == 'https')
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE


            request = Net::HTTP::Get.new(url.request_uri)
            request['Authorization'] = 'Bearer your_access_token'

            response = http.request(request)

            body = JSON.parse(response.body)
        end
    end
end