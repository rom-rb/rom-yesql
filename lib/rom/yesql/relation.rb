# frozen_string_literal: true

require "dry/core/class_attributes"

require "rom/relation"
require "rom/yesql/relation/class_interface"

module ROM
  module Yesql
    # Yesql relation subclass
    #
    # Class that inherits from this relation will be extended with methods
    # based on its gateway queries hash
    #
    # It also supports overriding query_proc
    #
    # @example
    #   conf = ROM::Configuration.new(
    #     :yesql, ['sqlite::memory', path: '/my/sql/queries/are/here']
    #   )
    #
    #   class Reports < ROM::Relation[:yesql]
    #     query_proc(proc { |name, query, *args|
    #       # magic if needed
    #     })
    #   end
    #
    #   conf.register_relation(Reports)
    #
    #   rom = ROM.container(conf)
    #
    #   rom.relations[:reports] # use like a normal rom relation
    #
    # @api public
    class Relation < ROM::Relation
      adapter :yesql

      extend Dry::Core::ClassAttributes

      defines :query_proc

      Materialized = Class.new(ROM::Relation)

      # Extends a relation with query methods
      #
      # This will only kick in if the derived dataset name matches the key under
      # which relation queries were registered. If not it is expected that the
      # dataset will be set manually
      #
      # @api private
      def self.inherited(klass)
        super
        klass.extend(ClassInterface)
      end

      # Extends provided klass with query methods
      #
      # @param [Class] klass A relation class
      # @param [Hash] queries A hash with name, query pairs for the relation
      #
      # @api private
      def self.define_query_methods(klass, queries)
        queries.each do |name, query|
          klass.class_eval do
            define_method(name) do |*args|
              Materialized.new(dataset.read(query_proc.call(name, query, *args)))
            end
          end
        end
      end

      # All loaded queries provided by gateway
      #
      # @return [Hash]
      #
      # @api private
      def self.queries
        @queries || {}
      end

      # Hook called by a gateway to load all configured queries
      #
      # @param [Hash] queries A hash with queries
      #
      # @api private
      def self.load_queries(queries)
        @queries = {}
        queries.each do |ds, ds_queries|
          @queries[ds] = ds_queries.each_with_object({}) do |(name, query), h|
            h[name] = query
          end
        end
        @queries
      end

      # Returns query proc set on a relation class
      #
      # By default this returns whatever was set in the gateway or the default
      # one which simply uses hash % query to evaluate a query string
      #
      # @return [Proc]
      #
      # @api public
      def query_proc
        self.class.query_proc
      end
    end
  end
end
