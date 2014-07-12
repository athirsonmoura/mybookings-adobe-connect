class ResourceTypesExtensions::AdobeConnectExtension::Extension < ResourceTypesExtensions::BaseExtension

  def self.after_booking_creation booking
    @adobe_connect = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance
    user = create_user_if_not_exists(booking.user_email)
  end

  def self.on_booking_start booking
    @adobe_connect = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance
    user = find_user_by_email(booking.user_email)
    create_meeting_for(booking, user)
  end

  def self.on_booking_end booking
  end

  private

  def self.create_user_if_not_exists(email)
    user = AdobeConnect::User.find({ email: email })
    return user unless user.nil?

    user = AdobeConnect::User.new({}, @adobe_connect)

    user.email = email
    user.first_name = email
    user.last_name = email
    user.username = email
    user.uuid = SecureRandom.uuid
    user.send_email = false

    user.save

    user
  end

  def self.find_user_by_email email
    AdobeConnect::User.find({ email: email })
  end

  def self.create_meeting_for booking, user
    my_meetings_folder_id = AdobeConnect::MeetingFolder.my_meetings_folder_id(@adobe_connect)
    meeting = AdobeConnect::Meeting.new({ name: booking.resource_name, folder_id: my_meetings_folder_id }, @adobe_connect)
    meeting.save
    meeting.private!
    meeting.add_host(user.id)
  end

end
