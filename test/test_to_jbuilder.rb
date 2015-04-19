require 'minitest_helper'
require 'json'

class TestToJbuilder < Minitest::Test
  def test_to_jbuilder_converts_a_json_hash_into_jbuilder
    actual = JSON.parse(<<-JSON_DATA).to_jbuilder(:message)
      {
        "content": "<p>This is <i>serious</i> monkey business</p>",
        "created_at": "2011-10-29T20:45:28-05:00",
        "updated_at": "2011-10-29T20:45:28-05:00",

        "author": {
          "name": "David H.",
          "email_address": "'David Heinemeier Hansson' <david@heinemeierhansson.com>",
          "url": "http://example.com/users/1-david.json"
        },

        "visitors": 15,

        "comments": [
          { "content": "Hello everyone!", "created_at": "2011-10-29T20:45:28-05:00" },
          { "content": "To you my good sir!", "created_at": "2011-10-29T20:47:28-05:00" }
        ],

        "attachments": [
          { "filename": "forecast.xls", "url": "http://example.com/downloads/forecast.xls" },
          { "filename": "presentation.pdf", "url": "http://example.com/downloads/presentation.pdf" }
        ]
      }
    JSON_DATA

    assert_equal fixture('json_hash'), actual
  end

  def test_to_jbuilder_converts_a_json_array_into_jbuilder
    actual = JSON.parse(<<-JSON_DATA).to_jbuilder(:users)
      [
        {
          "first_name": "Yuki",
          "last_name": "Nishijima",
          "email_address": "'Yuki Nishijima' <mail@yukinishijima.net>",
          "url": "http://www.yukinishijima.net"
        }
      ]
    JSON_DATA

    assert_equal fixture('json_array'), actual
  end

  private

  def fixture(path)
    open("#{__dir__}/fixtures/#{path}.jbuilder").read
  end
end
