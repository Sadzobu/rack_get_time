require_relative 'time_formatter'

class App

  CONTENT_TYPE = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    @request = Rack::Request.new(env)

    case @request.path
    when '/time'
      handle_time_request
    else
      handle_wrong_request
    end
  end

  private

  def handle_time_request
    time_formatter = TimeFormatter.new(Rack::Utils.parse_query(@request.query_string)['format'])

    if time_formatter.valid_format?
      body = ["#{time_formatter.time}\n"]
      Rack::Response.new(body, 200, CONTENT_TYPE).finish
    else
      body = ["Unknown time format #{time_formatter.wrong_params}\n"]
      Rack::Response.new(body, 400, CONTENT_TYPE).finish
    end
  end

  def handle_wrong_request
    Rack::Response.new([''], 404, CONTENT_TYPE).finish
  end
  
end
