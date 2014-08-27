class ResourceTypesExtensions::AdobeConnectExtension::Extension < ResourceTypesExtensions::BaseExtension

  def self.after_booking_creation booking
    load_adobe_connect_service

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.new(booking: booking)
    adobe_connect_extension_booking.save!

    user = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.create_user_if_not_exists(booking.user_email, @adobe_connect_service)
  end

  def self.on_booking_start booking
    load_adobe_connect_service

    adobe_connect_host_user = AdobeConnect::User.find({ email: ENV['ADOBECONNECT_USERNAME'] })
    meeting = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.create_meeting(booking.resource_name, adobe_connect_host_user, @adobe_connect_service)

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
    adobe_connect_extension_booking.update_attribute(:meeting_id, meeting.id)

    ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.set_meeting_presenter(adobe_connect_extension_booking, @adobe_connect_service)

    unless adobe_connect_extension_booking.participants.nil?
      ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.set_meeting_participants(adobe_connect_extension_booking, @adobe_connect_service)
    end
  end

  def self.on_booking_end booking
    load_adobe_connect_service

    adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
    meeting = AdobeConnect::Meeting.find_by_id(adobe_connect_extension_booking.meeting_id, @adobe_connect_service)
    meeting.delete
  end

  def self.actions_for booking
    actions = []

    if booking.pending?
      adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
      actions.push({ icon: 'user', text: I18n.t('.participants'), path: Rails.application.routes.url_helpers.adobe_connect_extension_booking_edit_participants_path(adobe_connect_extension_booking) })
    end

    actions
  end

  private

  def self.load_adobe_connect_service
    @adobe_connect_service = ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectSingleton.instance
  end

end
