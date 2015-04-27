class AdobeConnectSingleton

  AdobeConnect::Config.declare do
    username Rails.application.secrets.adobeconnect_username
    password Rails.application.secrets.adobeconnect_password
    domain   Rails.application.secrets.adobeconnect_domain
  end

  def self.instance
    @@conn ||= AdobeConnect::Service.new
    @@conn.log_in
    @@conn
  end

end
