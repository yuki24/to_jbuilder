module ToJbuilder
  module HashExtension
    prepend_features Hash

    def to_jbuilder(context, prefix: "@")
      longest_key_size = keys.sort_by(&:size).last.size
      buffer = ""

      each do |key, value|
        case value
        when Hash
          buffer << "json.#{key} do\n"
          buffer << value.to_jbuilder(key).split("\n").map{|s| "  #{s}\n" }.join
          buffer << "end\n"
        when Array
          buffer << value.to_jbuilder(key, offset: longest_key_size, context: context, prefix: prefix, toplevel: false)
        else
          buffer << "json.#{key.to_s.ljust(longest_key_size)} #{prefix}#{context}.#{key}\n"
        end
      end

      buffer
    end
  end
end
