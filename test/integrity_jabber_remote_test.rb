require "test/unit"
require "xmpp4r"
require "integrity/notifier/test"

require File.dirname(__FILE__) + "/../lib/integrity/notifier/jabber"

class IntegrityJabberRemoteTest < Test::Unit::TestCase
  include Integrity::Notifier::Test

  CONFIG_FILE = ENV['JABBER_CONFIG'] || '~/.integrity-jabber-test-config.yml'

  def notifier
    "Jabber"
  end

  def setup
    begin
      @test_config = File.open(File.expand_path(CONFIG_FILE)) do |io|
        YAML::load(io)
      end
      raise unless @test_config
    rescue => e
      puts "Place a yaml file at #{CONFIG_FILE} with jabber test config, for example:"
      puts File.read(File.dirname(__FILE__) + '/integrity-jabber-test-config.yml.sample')
      raise e
    end

    %w[ notifier receiver ].each do |client|
      @test_config[client] or raise "Need to configure #{client}: in #{CONFIG_FILE}"
      %w[ jid password server port ].each do |key|
        @test_config[client][key] or raise "Need to configure #{client}: #{key}: in #{CONFIG_FILE}"
      end
    end

    setup_database

    @notifier_config = {
      'jid'      => @test_config['notifier']['jid'],
      'password' => @test_config['notifier']['password'],
      'server'   => @test_config['notifier']['server'],
      'port'     => @test_config['notifier']['port'],

      'to'       => @test_config['receiver']['jid']
    }
  end

  def test_it_sends_successful_jabber_notification
    successful = Integrity::Commit.gen(:successful)

    message = deliver(successful)

    assert_not_nil message

    assert_equal @test_config['receiver']['jid'], message.to.to_s
    assert_equal @test_config['notifier']['jid'], message.from.to_s

    assert message.body.include?("successful")
    assert message.body.include?(successful.committed_at.to_s)
    assert message.body.include?(successful.author.name)
    assert message.body.include?(successful.output)
  end

  def test_it_sends_failed_jabber_notification
    failed = Integrity::Commit.gen(:failed)

    message = deliver(failed)

    assert_not_nil message

    assert_equal @test_config['receiver']['jid'], message.to.to_s
    assert_equal @test_config['notifier']['jid'], message.from.to_s

    assert message.body.include?("failed")
    assert message.body.include?(failed.committed_at.to_s)
    assert message.body.include?(failed.author.name)
    assert message.body.include?(failed.output)
  end

private

  def deliver(commit)
    receiver = ::Jabber::Client.new(@test_config['receiver']['jid'])
    receiver.add_message_callback do |message|
      Thread.main[:message] = message
      Thread.main.wakeup
    end

    Timeout::timeout(15) do
      receiver.connect(@test_config['receiver']['server'], @test_config['receiver']['port'])
      receiver.auth(@test_config['receiver']['password'])
      receiver.send(::Jabber::Presence.new(nil, nil, 127))

      Integrity::Notifier::Jabber.new(commit, @notifier_config.dup).deliver!
      Thread.stop # wait to be woken up by callback
    end

    Thread.current[:message]
  ensure
    receiver.close
  end

end
