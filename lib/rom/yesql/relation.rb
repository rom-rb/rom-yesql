require 'rom/relation'

module ROM
  module Yesql
    # Yesql relation subclass
    #
    # Class that inherits from this relation will be extended with methods
    # based on its repository queries hash
    #
    # It also supports overriding query_proc
    #
    # @example
    #   ROM.setup(:yesql, [uri, path: '/my/sql/queries/are/here'])
    #
    #   class Reports < ROM::Relation[:yesql]
    #     query_proc(proc { |name, query, *args|
    #       # magic if needed
    #     })
    #   end
    #
    #   rom = ROM.finalize.env
    #
    #   rom.relation(:reports) # use like a normal rom relation
    #
    # @api public
    class Relation < ROM::Relation
      defines :query_proc

      # Extends a relation with query methods
      #
      # @api private
      def self.inherited(klass)
        super
        queries[klass.dataset].each do |name, query|
          klass.class_eval do
            define_method(name) do |*args|
              ROM::Relation.new(
                dataset.read(query_proc.call(name, query, *args))
              )
            end
          end
        end
      end

      # All loaded queries provided by repository
      #
      # @return [Hash]
      #
      # @api privatek
      def self.queries
        @queries || {}
      end

      # Hook called by a repository to load all configured queries
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

      # Return query proc set on a relation class
      #
      # By default this returns whatever was set in the repository or the default
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
