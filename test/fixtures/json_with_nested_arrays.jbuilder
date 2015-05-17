json.array! @user do |user|
  json.tags @tags do |tag|
    json.foo  tag.foo
    json.hoge tag.hoge
  end
end
