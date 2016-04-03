require 'test_helper'
require 'speedtest/server'

describe Speedtest::Server do
  let(:servers) { Speedtest::Server.all }

  before do
    body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<settings>\n<servers><server url=\"http://88.84.191.230/speedtest/upload.php\" lat=\"70.0733\" lon=\"29.7497\" name=\"Vadso\" country=\"Norway\" cc=\"NO\" sponsor=\"Varanger KraftUtvikling AS\" id=\"4600\"  host=\"88.84.191.230:8080\" />\n<server url=\"http://speedtest.nornett.net/speedtest/upload.php\" lat=\"69.9403\" lon=\"23.3106\" name=\"Alta\" country=\"Norway\" cc=\"NO\" sponsor=\"Nornett AS\" id=\"4961\"  host=\"ns.nornett.net:8080\" />\n</servers>\n</settings>\n"
    stub_request(:get, "http://www.speedtest.net/speedtest-servers.php").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.speedtest.net', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: body, headers: {})
  end

  describe '.all' do
    it 'returns an instance of ServerCollection' do
      assert_instance_of Speedtest::ServerCollection, servers
    end

    it 'items are Server instance' do
      assert_instance_of Speedtest::Server, servers[0]
      assert_instance_of Speedtest::Server, servers[1]
    end

    it 'returns list of servers' do
      servers.count.must_equal 2
    end
  end

  it '#url' do
    servers[0].url.must_equal 'http://88.84.191.230'
    servers[1].url.must_equal 'http://speedtest.nornett.net'
  end

  describe '#localization' do
    it '#latitude' do
      servers[0].localization.latitude.must_equal 70.0733
      servers[1].localization.latitude.must_equal 69.9403
    end

    it '#longitude' do
      servers[0].localization.longitude.must_equal 29.7497
      servers[1].localization.longitude.must_equal 23.3106
    end
  end

  it '#distance_from' do
    servers[0].distance_from(servers[1].localization).must_equal 6.440473415052654
  end

  it '#ping'
end
