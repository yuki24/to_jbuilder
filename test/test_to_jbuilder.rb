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
          "name": "Yuki Nishijima",
          "email_address": "'Yuki Nishijima' <mail@yukinishijima.net>",
          "url": "http://www.yukinishijima.net"
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


  def test_to_jbuilder_converts_a_nested_json_hash_into_jbuilder
    actual = JSON.parse(<<-JSON_DATA).to_jbuilder(:users)
      {
        "writer": {
          "location": {
            "current": "New York, US",
            "hometown": "Tokyo, Japan"
          },
          "name": "Yuki Nishijima",
          "profile": {
            "gender": "male"
          }
        },
        "post": {
           "title":       "How does it work?",
           "description": "I don't know",
           "tags":        ["Ruby", "JSON"]
        }
      }
    JSON_DATA

    assert_equal fixture('json_nested_hash'), actual
  end

  def test_to_jbuilder_with_three_nested_hash
    actual = JSON.parse(<<-JSON_DATA).to_jbuilder(:file_groups)
      {
        "albums": [
          {
            "id": 85,
            "name": "My profile photos",
            "_links": {
              "self": {
                "href": "http://example.com/downloads/85"
              }
            },
            "files": [
              {
                "id": 181,
                "aws_object_key": "downloads/yuki24.jpg",
                "name": "yuki24.jpg",
                "_links": {
                  "self": {
                    "href": "http://example.com/downloads/85/yuki24.jpg"
                  }
                }
              }
            ]
          }
        ],
        "_links": {
          "self": {
            "href": "http://example.com/downloads"
          }
        }
      }
    JSON_DATA

    assert_equal fixture('json_three_nested_hash'), actual
  end

  private

  def fixture(path)
    open("#{__dir__}/fixtures/#{path}.jbuilder").read.strip
  end
end
