require "integrity"
require "xmpp4r"

module Integrity
  class Notifier
    class Jabber < Notifier::Base

      def self.to_haml
        File.read(File.dirname(__FILE__) + "/config.haml")
      end

      def initialize(commit, config={})
        super(commit, config)

        @client   = ::Jabber::Client.new(config.delete('jid'))
        @password = config.delete('password')
        @port     = config.delete('port')
        @server   = config.delete('server')
        @to       = config.delete('to').split(/\s+/)

        @server = nil  if @server.blank?
        @port   = 5222 if @port.blank?
      end

      def deliver!
        @client.connect(@server, @port.to_i)
        @client.auth(@password)

        @to.each do |to|
          message = ::Jabber::Message.new(to, full_message)
          message.type = :chat
          @client.send(message)
        end

        @client.close
      end

    end

    register Jabber
  end
end
