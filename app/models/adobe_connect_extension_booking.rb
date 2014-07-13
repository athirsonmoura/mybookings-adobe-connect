class AdobeConnectExtensionBooking < ActiveRecord::Base
  belongs_to :booking

  validate :participants_is_a_valid_email_list_separated_by_commas, allow_blank: true, unless: "participants.nil?"

  def update_participants participants_emails
    self.participants = participants_emails.gsub(/\s+/, '')
    self.save
  end

  private

  def participants_is_a_valid_email_list_separated_by_commas
    emails = participants.split(',')

    emails.each do |email|
      next if /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.match(email)

      errors.add(:participants, I18n.t('errors.invalid_email_list'))
      return
    end
  end
end
