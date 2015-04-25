json.albums @albums do |album|
  json.id   album.id
  json.name album.name

  json._links do
    json.self do
      json.href @self.href
    end
  end

  json.files @files do |file|
    json.id             file.id
    json.aws_object_key file.aws_object_key
    json.name           file.name

    json._links do
      json.self do
        json.href @self.href
      end
    end
  end
end

json._links do
  json.self do
    json.href @self.href
  end
end
