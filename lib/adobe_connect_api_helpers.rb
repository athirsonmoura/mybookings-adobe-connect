require 'adobe_connect_singleton'

class AdobeConnectAPIHelpers

  def self.create_user_if_not_exists email
    adobe_connect_user = AdobeConnect::User.find({ email: email }, AdobeConnectSingleton.instance)
    return adobe_connect_user unless adobe_connect_user.nil?

    user_attrs = {}
    user_attrs.merge!({'email' => email})
    user_attrs.merge!({'first_name' => email})
    user_attrs.merge!({'last_name' => email})
    user_attrs.merge!({'username' => email})
    user_attrs.merge!({'uuid' => SecureRandom.uuid})
    user_attrs.merge!({'send_email' => false})

    adobe_connect_user = AdobeConnect::User.new(user_attrs, AdobeConnectSingleton.instance)
    adobe_connect_user.save

    adobe_connect_user
  end

  def self.create_meeting meeting_name, adobe_connect_user
    my_meetings_folder_id = AdobeConnect::MeetingFolder.my_meetings_folder_id(AdobeConnectSingleton.instance)

    meeting = AdobeConnect::Meeting.new({ name: meeting_name, folder_id: my_meetings_folder_id }, AdobeConnectSingleton.instance)
    meeting.save

    meeting.private!
    meeting.add_host(adobe_connect_user.id)

    meeting
  end

  def self.provision_participants_for adobe_connect_extension_booking
    emails = adobe_connect_extension_booking.participants.split(',')

    emails.map { |email| AdobeConnectAPIHelpers.create_user_if_not_exists(email) }
  end

  def self.set_meeting_presenter_for adobe_connect_extension_booking
    meeting = AdobeConnect::Meeting.find_by_id(adobe_connect_extension_booking.meeting_id, AdobeConnectSingleton.instance)

    booking = adobe_connect_extension_booking.booking
    email = booking.user_email

    adobe_connect_user = AdobeConnect::User.find({ email: email }, AdobeConnectSingleton.instance)
    meeting.add_presenter(adobe_connect_user.id)
  end

  def self.set_meeting_participants adobe_connect_extension_booking
    meeting = AdobeConnect::Meeting.find_by_id(adobe_connect_extension_booking.meeting_id, AdobeConnectSingleton.instance)

    emails = adobe_connect_extension_booking.participants
    unless emails.nil?
      emails = emails.split(',')

      emails.each do |email|
        adobe_connect_user = AdobeConnect::User.find({ email: email }, AdobeConnectSingleton.instance)
        meeting.add_participant(adobe_connect_user.id)
      end
    end
  end

end
