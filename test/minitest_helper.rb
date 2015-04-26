$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'to_jbuilder'

begin
  require 'byebug'
  require 'did_you_mean'
rescue LoadError
end

require 'minitest/autorun'

begin
  MiniTest::Test
rescue NameError
  require 'minitest/unit'
  MiniTest::Test = MiniTest::Unit::TestCase
end
