require_relative 'time_formatter'

class App

  CONTENT_TYPE = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/time'
      handle_time_request(request)
    else
      response(404, [''])
    end

  end

  private

  def response(status, body)
    Rack::Response.new(body, status, CONTENT_TYPE).finish
  end

  def handle_time_request(request)
    time_formatter = TimeFormatter.new(Rack::Utils.parse_query(request.query_string)['format'])
    time_formatter.call

    if time_formatter.valid_format?
      response(200, ["#{time_formatter.time}\n"])
    else
      response(400, ["Unknown time format #{time_formatter.wrong_params}\n"])
    end
  end

end
