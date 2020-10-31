class CommunicationTemplate < ApplicationRecord
  belongs_to :user
  enum media: %i[simple_email branded_email sms]

  validates :name, presence: true
  validates :body, presence: true
  validates :key, presence: true, if: :is_system?

  def render_title(person)
    PersonTemplateRenderer.new(person, title).render
  end

  def render_body(person)
    PersonTemplateRenderer.new(person, body, markdown: !sms?).render
  end

  # TODO: Handle SMS.
  def send_to(person)
    mail = PersonMailer.with(communication_template: self, person: person).communication_template_email.deliver

    if persisted?
      person.notes.create note_type: "email-event", message: "Sent #{name} email to #{person.given_name}.", data: { communication_template_id: self.id }
    end

    person.attempt_contact!

    mail
  end

  class << self
    def by_key(key)
      where(key: key).first
    end
  end
end
