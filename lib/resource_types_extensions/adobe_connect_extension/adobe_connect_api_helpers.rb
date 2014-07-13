class ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers

  def self.create_user_if_not_exists email, adobe_connect_service
    adobe_connect_user = AdobeConnect::User.find({ email: email })
    return adobe_connect_user unless adobe_connect_user.nil?

    adobe_connect_user = AdobeConnect::User.new({}, adobe_connect_service)

    adobe_connect_user.email = email
    adobe_connect_user.first_name = email
    adobe_connect_user.last_name = email
    adobe_connect_user.username = email
    adobe_connect_user.uuid = SecureRandom.uuid
    adobe_connect_user.send_email = false

    adobe_connect_user.save

    adobe_connect_user
  end

  def self.create_meeting meeting_name, adobe_connect_user, adobe_connect_service
    my_meetings_folder_id = AdobeConnect::MeetingFolder.my_meetings_folder_id(adobe_connect_service)
    meeting = AdobeConnect::Meeting.new({ name: meeting_name, folder_id: my_meetings_folder_id }, adobe_connect_service)
    meeting.save
    meeting.private!
    meeting.add_host(adobe_connect_user.id)

    meeting
  end

  def self.provision_participants_for adobe_connect_extension_booking
    emails = adobe_connect_extension_booking.participants.split(',')

    adobe_connect_service = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance
    emails.map { |email| ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.create_user_if_not_exists(email, adobe_connect_service) }
  end

  def self.set_meeting_participants adobe_connect_extension_booking, adobe_connect_service
    meeting = AdobeConnect::Meeting.find_by_id(adobe_connect_extension_booking.meeting_id, adobe_connect_service)

    emails = adobe_connect_extension_booking.participants.split(',')
    emails.each do |email|
      adobe_connect_user = AdobeConnect::User.find({ email: email })
      meeting.add_participant(adobe_connect_user.id)
    end
  end

end
