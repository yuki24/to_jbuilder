require "to_jbuilder/version"
require "to_jbuilder/emitter"

require "active_support/concern"
require 'active_support/core_ext/string/inflections'

module ToJbuilder
  module CoreExtension
    prepend_features Array
    prepend_features Hash

    def to_jbuilder(key)
      parser = Psych::Parser.new(Psych::JSON::TreeBuilder.new).parse(to_json)
      io     = StringIO.new(''.encode('utf-8'))

      ToJbuilder::Visitors::Emitter.new(io, key.to_s).accept(parser.handler.root)
      io.string.tap(&:strip!)
    end
  end

  def self.model_names
    @model_names ||= if defined?(ActiveRecord::Base)
      ActiveRecord::Base.descendants.map(&:to_s).reject{|d| d.include?("HABTM") }.map(&:underscore)
    else
      []
    end
  end

  module TemplateGenerator
    extend ActiveSupport::Concern

    included do
      after_action do
        views_path    = Rails.root.join('app/views', params[:controller]).to_s
        template_path = Rails.root.join(views_path, params[:action]).to_s + ".json.jbuilder"

        if response.successful? && response.body.present?
          json    = JSON.parse(response.body)
          context = params[:controller].split("/").last
          context = context.singularize if params[:action] != "index"

          FileUtils.mkdir_p(views_path)
          File.open(template_path, "w") do |file|
            file.write json.to_jbuilder(context)
          end
        end
      end
    end
  end
end
