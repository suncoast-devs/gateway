# TODO: Move inbox stream to another channel, maybe something like "AppStateChannel"
class CommunicationChannel < ApplicationCable::Channel
  def subscribed
    stream_inbox
  end

  def follow(data)
    person = Person.find(data["id"])
    stop_all_streams
    stream_inbox
    stream_for person
  end

  def unfollow
    stop_all_streams
    stream_inbox
  end

  def mark_as_read(data)
    communication = Communication.find(data["id"])
    communication.update is_unread: false
    CommunicationChannel.broadcast_unread
  end

  def self.broadcast_unread
    ActionCable.server.broadcast "inbox", { unread: Communication.incoming.unread.count }
  end

  def self.broadcast_communication(communication)
    CommunicationChannel.broadcast_unread if communication.incoming?

    rendered_message = ApplicationController.render(
      partial: "communications/message",
      locals: { communication: communication },
    )

    # FIXME: EW...
    camelized = OliveBranch::Transformations.transform(
      JSON.parse(rendered_message),
      OliveBranch::Transformations.method(:camelize)
    )

    CommunicationChannel.broadcast_to(communication.person, camelized)
  end

  private

  def stream_inbox
    stream_from "inbox"
    CommunicationChannel.broadcast_unread
  end
end
