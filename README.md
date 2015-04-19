# ToJbuilder

Convet any JSON data to jbuilder templates!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'to_jbuilder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install to_jbuilder

## Usage

```ruby
require 'to_jbuilder'

# Ruby 2.2 or higher is required to run this code.
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
}.to_jbuilder(:message)
```

will generate:

```ruby
json.content    @message.content
json.created_at @message.created_at
json.updated_at @message.updated_at

json.author do
  json.name          @author.name
  json.email_address @author.email_address
  json.url           @author.url
end

json.visitors @message.visitors

json.comments @comments do |comment|
  json.content    comment.content
  json.created_at comment.created_at
end

json.attachments @attachments do |attachment|
  json.filename attachment.filename
  json.url      attachment.url
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/to_jbuilder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
