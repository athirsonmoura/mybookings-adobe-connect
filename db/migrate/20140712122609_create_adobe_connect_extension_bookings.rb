class CreateAdobeConnectExtensionBookings < ActiveRecord::Migration
  def change
    create_table(:adobe_connect_extension_bookings) do |t|
      t.integer :booking_id
      t.integer :meeting_id
      t.text :participants

      t.timestamps
    end
  end
end
