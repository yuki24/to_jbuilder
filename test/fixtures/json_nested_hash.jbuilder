json.writer do
  json.location do
    json.current  @location.current
    json.hometown @location.hometown
  end

  json.name @writer.name

  json.profile do
    json.gender @profile.gender
  end
end

json.post do
  json.title       @post.title
  json.description @post.description
  json.tags        @post.tags
end
