json.content     @message.content
json.created_at  @message.created_at
json.updated_at  @message.updated_at
json.author do
  json.name          @author.name
  json.email_address @author.email_address
  json.url           @author.url
end
json.visitors    @message.visitors
json.comments @comments do |comment|
  json.content    comment.content
  json.created_at comment.created_at
end
json.attachments @attachments do |attachment|
  json.filename attachment.filename
  json.url      attachment.url
end
