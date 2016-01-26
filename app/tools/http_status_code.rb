require 'abstract_controller/rendering'
class HttpStatusCode

    def self.forbidden(data = nil)
        json_data = {
            error: 'Forbidden',
            status: 400
        }
        if data.nil?
            json_data[:data] = data
        end
        {
            json: json_data,
            status: 400
        }
    end

    def self.ok(data = nil)
        json_data = {
            status: 200
        }
        unless data.nil?
            json_data[:data] = data
        end
        {
            json: json_data,
            status: 200
        }
    end
end