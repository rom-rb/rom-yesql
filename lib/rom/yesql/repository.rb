require 'sequel'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    # Yesql repository exposes access to configured SQL queries
    #
    # @example
    #   # Load all queries from a specific path
    #   ROM::Yesql::Repository.new(uri, path: '/path/to/my_queries')
    #
    #   # Provide queries explicitly using a hash
    #   ROM::Yesql::Repository.new(uri, queries: {
    #     reports: {
    #       all_users: 'SELECT * FROM users'
    #     }
    #   })
    #
    #   # Override default query proc handler
    #   ROM::Yesql::Repository.new(uri, query_proc: proc { |name, query, *args|
    #     # do something to return an sql string
    #   })
    #
    # @api public
    class Repository < ROM::Repository
      include Options

      option :path, reader: true
      option :queries, type: Hash, default: EMPTY_HASH
      option :query_proc, reader: true, default: proc { |repository|
        proc do |_name, query, opts|
          query % opts
        end
      }

      # Return Sequel database connection
      #
      # @return [Sequel::Database]
      #
      # @api private
      attr_reader :connection

      # Hash with loaded queries indexed using dataset names
      #
      # @return [Hash]
      #
      # @api private
      attr_reader :queries

      # @api private
      def initialize(uri, options = {})
        super
        @connection = Sequel.connect(uri, options)
        initialize_queries
        Relation.query_proc(query_proc)
        Relation.load_queries(queries)
      end

      # Initialize a dataset
      #
      # Since all relations use the same dataset we simply create one instance
      #
      # @api private
      def dataset(_name)
        @dataset ||= Dataset.new(connection)
      end

      # @api private
      def dataset?(_name)
        ! @dataset.nil?
      end

      private

      # Load queries from filesystem if :path was provided
      #
      # @api private
      def initialize_queries
        @queries = options[:queries].dup

        return unless path

        Dir["#{path}/*"].each do |dir|
          dataset = File.basename(dir).to_sym
          @queries[dataset] = {}
          Dir["#{dir}/**/*.sql"].each do |file|
            name = File.basename(file, '.*').to_sym
            sql = File.read(file)
            @queries[dataset][name] = sql.strip
          end
        end
      end
    end
  end
end
