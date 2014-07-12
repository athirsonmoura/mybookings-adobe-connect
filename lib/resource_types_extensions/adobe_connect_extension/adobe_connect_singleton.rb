class ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton

  AdobeConnect::Config.declare do
    username ENV['ADOBECONNECT_USERNAME']
    password ENV['ADOBECONNECT_PASSWORD']
    domain   ENV['ADOBECONNECT_DOMAIN']
  end

  def self.instance
    @@conn ||= AdobeConnect::Service.new
    @@conn.log_in unless @@conn.authenticated?
    @@conn
  end

end
