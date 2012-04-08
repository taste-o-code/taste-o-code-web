# Patches to make ActiveAdmin work with Mongoid.
# For more information see https://github.com/gregbell/active_admin/issues/26 and https://gist.github.com/1809524.

require 'active_admin'
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

# For some reason this part causes "undefined local variable or method `gflash'" error while running tests on Spork.
unless Rails.env.test?
  require 'active_admin/resource_controller'

  module ActiveAdmin

    class ResourceController
      # Use #desc and #asc for sorting.
      def sort_order(chain)
        params[:order] ||= active_admin_config.sort_order
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
