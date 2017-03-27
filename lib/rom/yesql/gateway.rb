require 'sequel'

require 'rom/initializer'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    # Yesql gateway exposes access to configured SQL queries
    #
    # Relations created with datasets provided by this gateway automatically
    # expose access to gateway's queries.
    #
    # @api public
    class Gateway < ROM::Gateway
      extend Initializer

      adapter :yesql

      # @!attribute [r] uri
      #  @return [String] connection string
      param :uri

      # @!attribute [r] path
      #   @return [String] a path to files with SQL queries
      option :path, reader: true, optional: true

      # @!attribute [r] queries
      #   @return [Hash] a hash with queries
      option :queries, default: -> { EMPTY_HASH }

      # @!attribute [r] query_proc
      #   This defaults to simple interpolation of the query using option hash passed to a relation
      #   @return [Proc] custom query proc for pre-processing a query string
      option :query_proc, reader: true, default: proc { |_gateway|
        proc do |_name, query, opts|
          query % opts
        end
      }

      # @!attribute [r] connection
      #   @return [Sequel::Database] Sequel database connection
      attr_reader :connection

      # Initializes a yesql gateway
      #
      # @example
      #   # Load all queries from a specific path
      #   ROM::Yesql::Gateway.new(uri, path: '/path/to/my_queries')
      #
      #   # Provide queries explicitly using a hash
      #   ROM::Yesql::Gateway.new(uri, queries: {
      #     reports: {
      #       all_users: 'SELECT * FROM users'
      #     }
      #   })
      #
      #   # Override default query proc handler
      #   ROM::Yesql::Gateway.new(uri, query_proc: proc { |name, query, *args|
      #     # do something to return an sql string
      #   })
      #
      # @param uri [String]
      #
      # @param options [Hash]
      #   @option :path [String]
      #   @option :queries [Hash]
      #   @option :query_proc [Proc]
      #
      # @api public
      def initialize(*)
        super
        @connection = Sequel.connect(uri, options)
        @queries = @queries.merge(load_queries(path)).freeze
        Relation.query_proc(query_proc)
        Relation.load_queries(queries)
      end

      # Initializes a dataset
      #
      # Since all relations use the same dataset we simply create one instance
      #
      # @return [Dataset]
      #
      # @api private
      def dataset(_name)
        @dataset ||= Dataset.new(connection)
      end

      # Returns if a dataset with the given name exists
      #
      # This always returns true because all relations use the same dataset
      #
      # @return [True]
      #
      # @api private
      def dataset?(_name)
        ! @dataset.nil?
      end

      private

      # Loads queries from filesystem if :path was provided
      #
      # @api private
      def load_queries(path)
        if path.nil?
          {}
        else
          Dir["#{path}/*"].each_with_object({}) do |dir, fs_queries|
            dataset = File.basename(dir).to_sym

            fs_queries[dataset] = Dir["#{dir}/**/*.sql"].each_with_object({}) do |file, ds_queries|
              query_name = File.basename(file, '.*').to_sym
              sql = File.read(file).strip

              ds_queries[query_name] = sql
            end
          end
        end
      end
    end
  end

  register_adapter(:yesql, ROM::Yesql)
end
