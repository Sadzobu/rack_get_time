require_relative 'time_formatter'

class App

  CONTENT_TYPE = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    @request = Rack::Request.new(env)

    @response = Rack::Response.new([''], 404, CONTENT_TYPE)

    case @request.path
    when '/time'
      handle_time_request
    else
      handle_wrong_request
    end

    @response.finish
  end

  private

  def handle_time_request
    time_formatter = TimeFormatter.new(Rack::Utils.parse_query(@request.query_string)['format'])

    if time_formatter.valid_format?
      @response.body = ["#{time_formatter.time}\n"]
      @response.status = 200
    else
      @response.body = ["Unknown time format #{time_formatter.wrong_params}\n"]
      @response.status = 400
    end
  end

  def handle_wrong_request
    # default response handles this case
  end
  
end
