module Helpers
    module HttpClientHelper
        def fetch_data(url)
            parsed_url = URI.parse(url)
            http = Net::HTTP.new(parsed_url.host, parsed_url.port)
            http.use_ssl = (parsed_url.scheme == 'https')
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE


            request = Net::HTTP::Get.new(parsed_url.request_uri)
            request['Authorization'] = 'Bearer your_access_token'

            response = http.request(request)

            body = JSON.parse(response.body)
        end
    end
end