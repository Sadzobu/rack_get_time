class TimeFormatter

  FORMATS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  attr_reader :wrong_params

  def initialize(formats)
    @formats = formats.split(',')
    @wrong_params = []
    @time_format = []
    parse_formats
  end

  def valid_format?
    @wrong_params.empty?
  end

  def time
    Time.now.strftime(@time_format.join('-'))
  end

  private

  def parse_formats
    @formats.each do |x|
      if FORMATS.keys.include?(x)
        @time_format << FORMATS[x]
      else
        @wrong_params << x
      end
    end
  end

end
