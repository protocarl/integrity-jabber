require "integrity"
require "xmpp4r"

module Integrity
  class Notifier
    class Jabber < Notifier::Base

      def self.to_haml
        File.read(File.dirname(__FILE__) + "/config.haml")
      end

      def initialize(commit, config)
        config.delete_if { |k,v| v.blank? }

        @client       = ::Jabber::Client.new(config.delete('jid'))
        @password     = config.delete('password')
        @to           = config.delete('to').split(/\s+/)
        @server       = config.delete('server')
        @port         = config.delete('port') || '5222'
        @stanza_limit = config.delete('stanza_limit') || '65536'

        super(commit, config)
      end

      def deliver!
        @client.connect(@server, @port.to_i)
        @client.auth(@password)

        body = full_message[0...@stanza_limit.to_i]

        @to.each do |to|
          message = ::Jabber::Message.new(to, body)
          message.type = :chat
          @client.send(message)
        end

        @client.close
      end

    end

    register Jabber
  end
end
