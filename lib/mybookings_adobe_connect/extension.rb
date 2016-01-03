module ResourceTypesExtensions
  module MyBookingsAdobeConnect

    class Extension < ResourceTypesExtensions::BaseExtension

      def self.after_booking_creation booking
        AdobeConnectExtensionBooking.create( booking: booking )
        user = AdobeConnectAPIHelpers.create_user_if_not_exists(booking.user_email)
      end

      def self.on_booking_start booking
        adobe_connect_host_user = AdobeConnect::User.find({ email: Rails.application.secrets.adobeconnect_username }, AdobeConnectSingleton.instance)
        meeting = AdobeConnectAPIHelpers.create_meeting(booking.resource_name, adobe_connect_host_user)

        adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
        adobe_connect_extension_booking.update_attribute(:meeting_id, meeting.id)

        AdobeConnectAPIHelpers.set_meeting_presenter_for(adobe_connect_extension_booking)
        AdobeConnectAPIHelpers.set_meeting_participants(adobe_connect_extension_booking)
      end

      def self.on_booking_end booking
        adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)
        meeting_id = adobe_connect_extension_booking.meeting_id
        meeting = AdobeConnect::Meeting.find_by_id(meeting_id, AdobeConnectSingleton.instance)
        meeting.delete
      end

      def self.actions_for booking
        actions = []

        adobe_connect_extension_booking = AdobeConnectExtensionBooking.find_by_booking_id(booking)

        if booking.pending?
          url_helpers = Rails.application.routes.url_helpers

          actions.push({
            icon: 'user',
            text: I18n.t('.participants'),
            path: url_helpers.adobe_connect_extension_booking_edit_participants_path(adobe_connect_extension_booking)
          })
        end

        if booking.occurring?
          meeting_id = adobe_connect_extension_booking.meeting_id
          meeting = AdobeConnect::Meeting.find_by_id(meeting_id, AdobeConnectSingleton.instance)

          actions.push({
            icon: 'link',
            text: I18n.t('.open_meeting'),
            path: "#{Rails.application.secrets.adobeconnect_domain}#{meeting.url_path}",
            target: '_blank'
          })
        end

        actions
      end

    end

  end
end
