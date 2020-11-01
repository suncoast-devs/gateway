class CommunicationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'inbox'
    CommunicationChannel.broadcast_unread
  end

  def self.broadcast_unread
    ActionCable.server.broadcast 'inbox', { unread: Communication.incoming.where(is_unread: true).count }
  end
end
