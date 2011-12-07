require 'rails/generators'

module Bootstrap
  module Generators
    class FormGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator creates form partial file for a model."
      argument :model_name, :type => :string, :required => true
      argument :dir_name,   :type => :string, :optional => true
      
      attr_reader :fields
      
      def generate_form
        klass = Class.const_get(model_name.classify)
        dir = dir_name || model_name.pluralize
        @fields = klass.columns.inject({}) do |hsh, col|
          hsh[col.name] = col.type unless %w(id created_at updated_at).include?(col.name)
          hsh
        end
        ext = Rails.application.config.generators.options[:rails][:template_engine] || :erb
        template "_form.html.#{ext}.erb", "app/views/#{dir}/_form.html.#{ext}"
      end
    end
  end
end