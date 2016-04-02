require 'test_helper'

describe Speedtest do
  it '.version' do
    Speedtest::VERSION.wont_be :nil?
  end
end
