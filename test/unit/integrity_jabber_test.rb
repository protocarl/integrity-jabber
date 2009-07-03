require File.dirname(__FILE__) + '/../test_helper'

class IntegrityJabberTest < Test::Unit::TestCase
  include Integrity::Notifier::Test

  def notifier
    "Jabber"
  end

  def setup
    setup_database

    @config = {
      'jid' => 'notifier@localhost',
      'password' => 'secret',
      'to' => 'receiver@localhost'
    }

    @commit = Integrity::Commit.gen(:successful)

    @client = stub_everything('jabber_client', :send => nil)
    ::Jabber::Client.stubs(:new).returns(@client)
  end

  def test_configuration_form
    assert form_have_tag?("h3", :content => "Jabber Server Configuration")

    assert provides_option?("jid",      "foo@example.org")
    assert provides_option?("password", "secret")
    assert provides_option?("server",   "example.org")
    assert provides_option?("port",     "5222")
    assert provides_option?("to",       "bar@example.org")
  end

  def test_configuration_with_server
    @client.expects(:connect).with('example.com', anything)

    Integrity::Notifier::Jabber.new(@commit, @config.merge('server' => 'example.com')).deliver!
  end

  def test_configuration_without_server
    @client.expects(:connect).with(nil, anything)

    Integrity::Notifier::Jabber.new(@commit, @config.merge('server' => '')).deliver!
  end

  def test_configuration_with_port
    @client.expects(:connect).with(anything, 5223)

    Integrity::Notifier::Jabber.new(@commit, @config.merge('port' => '5223')).deliver!
  end

  def test_configuration_without_port
    @client.expects(:connect).with(anything, 5222)

    Integrity::Notifier::Jabber.new(@commit, @config.merge('port' => '')).deliver!
  end

  def test_sends_messages
    @client.expects(:send).with { |message| message.to.to_s == 'client@localhost' }

    Integrity::Notifier::Jabber.new(@commit, @config.merge('to' => 'client@localhost')).deliver!
  end

  def test_sends_multiple_messages
    @client.expects(:send).with { |message| message.to.to_s == 'client1@localhost' }
    @client.expects(:send).with { |message| message.to.to_s == 'client2@localhost/test' }
    @client.expects(:send).with { |message| message.to.to_s == 'client3@localhost/resource' }

    Integrity::Notifier::Jabber.new(@commit, @config.merge('to' => 'client1@localhost client2@localhost/test client3@localhost/resource')).deliver!
  end

  def test_closes_connection
    @client.expects(:close)

    Integrity::Notifier::Jabber.new(@commit, @config).deliver!
  end

end
