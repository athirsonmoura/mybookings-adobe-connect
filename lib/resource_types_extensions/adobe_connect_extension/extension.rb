class ResourceTypesExtensions::AdobeConnectExtension::Extension < ResourceTypesExtensions::BaseExtension

  def self.after_booking_creation booking
    @adobe_connect = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.new(booking: booking)
    adobe_connect_extension_booking.save!

    user = create_user_if_not_exists(booking.user)

    # TODO: create guests users if not exists
  end

  def self.on_booking_start booking
    @adobe_connect = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance

    adobe_connect_user = find_user_by_email(booking.user_email)
    meeting = create_meeting_for(booking, adobe_connect_user)

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
    adobe_connect_extension_booking.update_attribute(:meeting_id, meeting.id)

    # TODO: assigns participants to the meeting room
  end

  def self.on_booking_end booking
    @adobe_connect = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
    meeting = AdobeConnect::Meeting.find_by_id(adobe_connect_extension_booking.meeting_id, @adobe_connect)
    meeting.delete
  end

  private

  def self.create_user_if_not_exists(user)
    adobe_connect_user = AdobeConnect::User.find({ email: user.email })
    return adobe_connect_user unless adobe_connect_user.nil?

    adobe_connect_user = AdobeConnect::User.new({}, @adobe_connect)

    adobe_connect_user.email = user.email
    adobe_connect_user.first_name = user.email
    adobe_connect_user.last_name = user.email
    adobe_connect_user.username = user.email
    adobe_connect_user.uuid = SecureRandom.uuid
    adobe_connect_user.send_email = false

    adobe_connect_user.save

    adobe_connect_user
  end

  def self.find_user_by_email email
    AdobeConnect::User.find({ email: email })
  end

  def self.create_meeting_for booking, adobe_connect_user
    my_meetings_folder_id = AdobeConnect::MeetingFolder.my_meetings_folder_id(@adobe_connect)
    meeting = AdobeConnect::Meeting.new({ name: booking.resource_name, folder_id: my_meetings_folder_id }, @adobe_connect)
    meeting.save
    meeting.private!
    meeting.add_host(adobe_connect_user.id)

    meeting
  end

end
