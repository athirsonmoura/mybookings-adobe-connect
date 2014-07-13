class AdobeConnectExtensionBookingsController < BaseController

  before_action :load_adobe_connect_extension_booking, only: [:edit_participants, :update_participants]
  before_action :adobe_connect_extension_booking_params, only: [:update_participants]

  def edit_participants; end

  def update_participants
    return render 'edit_participants' unless @adobe_connect_extension_booking.update_participants(adobe_connect_extension_booking_params[:participants])

    ResourceTypesExtensions::AdobeConnectExtension::AdobeConnectAPIHelpers.provision_participants_for(@adobe_connect_extension_booking)
    return redirect_to bookings_path
  end

  private

  def adobe_connect_extension_booking_params
    params.require(:adobe_connect_extension_booking).permit(:participants)
  end

  def load_adobe_connect_extension_booking
    adobe_connect_extension_booking_id = params[:id] || params[:adobe_connect_extension_booking_id]

    @adobe_connect_extension_booking = AdobeConnectExtensionBooking.find(adobe_connect_extension_booking_id)
  end

end
