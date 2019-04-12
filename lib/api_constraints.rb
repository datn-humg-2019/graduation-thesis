class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
    @domain = options[:domain]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.#{@domain}+json; version=#{@version}")
  end
end
