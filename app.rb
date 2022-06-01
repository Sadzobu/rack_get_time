class App

  FORMATS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  def call(env)
    @env = env
    @status = response_status
    headers = { 'Content-Type' => 'text/plain' }
    body = response_body
    [@status, headers, body]
  end

  private

  def response_status
    return 404 if @env['PATH_INFO'] != '/time'

    return 400 unless valid_format?

    200
  end

  def parse_format
    Rack::Utils.parse_query(@env['QUERY_STRING'])['format']
  end

  def missing_keys
    parse_format.split(',').difference(FORMATS.keys)
  end

  def valid_format?
    missing_keys.empty?
  end

  def time_format
    parse_format.split(',').map { |x| FORMATS[x] }.join('-')
  end

  def response_body
    case @status
    when 400
      ["Unknown time format #{missing_keys}\n"]
    when 404
      []
    when 200
      ["#{Time.now.strftime(time_format)}\n"]
    end
  end
end
