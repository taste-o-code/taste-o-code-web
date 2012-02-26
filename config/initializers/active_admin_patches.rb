# Patches to make ActiveAdmin work with Mongoid.
# For more information see https://github.com/gregbell/active_admin/issues/26 and https://gist.github.com/1809524.

require "active_admin"
require "active_admin/resource_controller"
require 'ostruct'

module ActiveAdmin
  class Namespace
    # Disable comments
    def comments?
      false
    end
  end

  class Resource
    def resource_table_name
      controller.resources_configuration[:self][:route_instance_name]
    end

    # Disable filters
    def add_default_sidebar_sections
    end
  end

  class ResourceController
    # Use #desc and #asc for sorting.
    def sort_order(chain)
      params[:order] ||= active_admin_config.sort_order
      table_name = active_admin_config.resource_table_name
      if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        chain.send($2, $1)
      else
        chain # just return the chain
      end
    end

    # Disable filters
    def search(chain)
      chain
    end

  end

  # We use mongoid and it's Criteria class doesn't have reorder method. So just remove it.
  # We can have problems with https://github.com/gregbell/active_admin/issues/994, I don't know exactly.
  module Views
    module Pages
      class Index < Base
        def items_in_collection?
          # Was
          # collection.reorder("").limit(1).exists?

          # Now
          collection.limit(1).exists?
        end
      end
    end
  end


end

module Mongoid
  module ActiveAdmin

    ACTIVE_ADMIN_HIDDEN_COLUMNS = %w(_id _type)
    ACTIVE_ADMIN_COLUMN_TYPES   = { Bignum => :integer, Array => :string }

    def column_for_attribute(attr)
      self.class.columns.detect { |c| c.name == attr.to_s }
    end

    module ClassMethods
      def content_columns
        fields.map do |name, field|
          next if ACTIVE_ADMIN_HIDDEN_COLUMNS.include?(name)
          OpenStruct.new.tap do |c|
            c.name = field.name
            c.type = ACTIVE_ADMIN_COLUMN_TYPES[field.type] || field.type.to_s.downcase.to_sym
          end
        end.compact
      end

      def columns
        content_columns
      end
    end

  end
end

require 'mongoid/document'

Mongoid::Document.send :include, Mongoid::ActiveAdmin
Mongoid::Document::ClassMethods.send :include, Mongoid::ActiveAdmin::ClassMethods


### PATCH THEM ALL!!!
### Patch for relative paths in sass-rails
require 'sass/rails/importer'

if defined?(Sass::Rails::VERSION) && Sass::Rails::VERSION[0..3] >= '3.1.'
  Rails.logger.warn ' == MONKEY == Patching sass-rails: https://github.com/rails/sass-rails/pull/70'
  Rails.logger.warn " == MONKEY == Please update #{__FILE__} once Sass::Rails upstream has pulled in the fix"
  # monkey patch to incorporate https://github.com/rails/sass-rails/pull/70
  module Sass
    module Rails
      class Importer
        def resolve(name, base_pathname = nil)
          name = Pathname.new(name)
          if base_pathname && base_pathname.to_s.size > 0
            root = context.pathname.dirname
            name = base_pathname.relative_path_from(root).join(name)
          end
          partial_name = name.dirname.join("_#{name.basename}")
          @resolver.resolve(name) || @resolver.resolve(partial_name)
        end
      end
    end
  end
end
