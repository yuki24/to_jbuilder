module ToJbuilder
  module ArrayExtension
    prepend_features Array

    def to_jbuilder(key, offset: 0, prefix: "@", context: "", toplevel: true)
      buffer = ""
      key    = key.to_s

      case first
      when Hash
        if toplevel
          buffer << "json.array! #{prefix}#{key.pluralize} do |#{key.singularize}|\n"
        else
          buffer << "json.#{key.pluralize} #{prefix}#{key.pluralize} do |#{key.singularize}|\n"
        end

        buffer << first.to_jbuilder(key.to_s.singularize, prefix: "").split("\n").map{|s| "  #{s}\n" }.join
        buffer << "end\n"
      when Array
        if toplevel
          buffer << "json.array! #{prefix}#{key.pluralize} do |#{key.singularize}|\n"
        else
          buffer << "json.#{key.pluralize} #{prefix}#{key.pluralize} do |#{key.singularize}|\n"
        end

        buffer << first.to_jbuilder(key, context: context, prefix: "").split("\n").map{|s| "  #{s}\n" }.join
        buffer << "end\n"
      else
        buffer << "json.#{key.to_s.ljust(offset)} #{prefix}#{context}.#{key}\n"
      end

      buffer
    end
  end
end
