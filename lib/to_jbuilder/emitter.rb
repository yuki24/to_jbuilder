require 'psych'

module ToJbuilder
  module Visitors
    class Emitter < Psych::Visitors::Emitter
      def initialize(io, resource_name)
        @handler = ToJbuilder::Emitter.new(io, resource_name)
      end
    end
  end

  class Emitter < ::Psych::Emitter
    DOCUMENT_START = :document_start
    DOCUMENT_END   = :document_end
    PAIR_KEY       = :pair_key
    PAIR_VALUE     = :pair_value
    HASH_START     = :hash_start
    HASH_END       = :hash_end
    ARRAY_START    = :array_start
    ARRAY_END      = :array_end

    EMPTY = ' '.freeze

    class JbuilderLine < Struct.new(:object, :key, :value, :prefix, :indent, :line_break)
      alias line_break? line_break

      def to_jbuilder(key_offset = 0)
        "#{("\n" if line_break?)}#{indent}json.#{key.ljust(key_offset)} #{prefix}#{object}.#{key}\n"
      end

      def to_hash_key
        "#{("\n" if line_break?)}#{indent}json.#{key} do\n"
      end
    end

    class JbuilderArray < Struct.new(:line, :key)
      def to_jbuilder
        if key
          "json.array! @#{key} do |#{key.singularize}|\n"
        else
          "#{("\n" if line.line_break?)}#{line.indent}json.#{line.key} @#{line.key} do |#{line.key.singularize}|\n"
        end
      end
    end

    class Nesting < Struct.new(:name, :type, :sequence_processed)
      def sequence_processed?
        !! sequence_processed
      end
    end

    def initialize(io, resource_name)
      @io, @resource_name = io, resource_name

      @jbuilder_array     = nil
      @jbuilder_lines     = []
      @nesting            = [Nesting.new(@resource_name, :root)]
      @trace              = []
    end

    def end_stream
      # nothing to do...
    end

    def start_document(version, tag_directives, implicit)
      raise "#{__method__} was called more than once." if @trace.include?(DOCUMENT_START)
      @trace << DOCUMENT_START
    end

    def end_document(implicit_end)
      if @trace.include?(DOCUMENT_END)
        raise "#{__method__} was called more than once."
      else
        @trace << DOCUMENT_END
      end
    end

    def start_mapping(anchor, tag, implicit, style)
      case @trace.last
      when ARRAY_START
        flush!

        unless @nesting.last.sequence_processed?
          @io.write "\n" if @trace[-3] != ARRAY_END && @trace[-3] != HASH_START
          @io.write @jbuilder_array.to_jbuilder
        end
      when PAIR_KEY
        line = @jbuilder_lines.pop
        flush!
        line.line_break = true if @trace[-2] != HASH_START
        @io.write line.to_hash_key
        @nesting.push Nesting.new(line.key.singularize, HASH_START)
      end

      @trace << HASH_START
    end

    def end_mapping
      flush!
      @nesting.last.sequence_processed = true if within_array? && !@nesting.last.sequence_processed?

      if @nesting.size > 1 && !within_array?
        @nesting.pop
        @io.write "#{indent}end\n"
      end

      @trace << HASH_END
    end

    def start_sequence(anchor, tag, implicit, style)
      case @trace.last
      when PAIR_KEY
        line = @jbuilder_lines.pop
        line.line_break = false if @trace[-2] == HASH_END

        @jbuilder_array = JbuilderArray.new(line)
      when DOCUMENT_START
        @jbuilder_array = JbuilderArray.new(nil, @nesting.last.name)
      end

      @nesting.push Nesting.new((@jbuilder_array.line || @jbuilder_array).key.singularize, ARRAY_START, @nesting.last.sequence_processed)
      @trace << ARRAY_START
    end

    def end_sequence
      case @trace.last
      when ARRAY_START
        @nesting.pop
        @jbuilder_lines << @jbuilder_array.line unless @nesting.last.sequence_processed?
      when PAIR_VALUE
        @nesting.pop
        @jbuilder_lines << @jbuilder_array.line
      when HASH_END
        @nesting.pop
        @io.write "#{indent}end\n" unless @nesting.last.sequence_processed?
      end

      @trace << ARRAY_END
    end

    def scalar(value, anchor, tag, plain, quoted, style)
      return if @nesting.last.sequence_processed?

      case @trace.last
      when DOCUMENT_START, HASH_START, HASH_END, ARRAY_END, PAIR_VALUE
        line_break = @trace.last == ARRAY_END || @trace.last == HASH_END
        prefix     = within_array? ? "" : "@"

        @jbuilder_lines << JbuilderLine.new(@nesting.last.name, value, nil, prefix, indent, line_break)
        @trace << PAIR_KEY
      when ARRAY_START
        @nesting.last.sequence_processed = true

        @trace << PAIR_VALUE
      when PAIR_KEY
        @jbuilder_lines.last.value = value

        @trace << PAIR_VALUE
      else
        raise "Syntax error."
      end
    end

    def alias(anchor)
      # nothing to do...
    end

    private

    def within_array?
      @nesting.last.type == ARRAY_START
    end

    def indent
      EMPTY * (@nesting.size - 1) * 2
    end

    def flush!
      key_length = @jbuilder_lines.map(&:key).map(&:length).sort.last

      @jbuilder_lines.each do |line|
        @io.write line.to_jbuilder(key_length)
      end
      @jbuilder_lines.clear
    end
  end
end
