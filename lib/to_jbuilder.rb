require "to_jbuilder/version"
require "to_jbuilder/core_ext/array"
require "to_jbuilder/core_ext/hash"

require "active_support/concern"
require 'active_support/core_ext/string/inflections'

module ToJbuilder
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
