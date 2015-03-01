require 'sequel'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    class Repository < ROM::Repository
      include Options

      option :path, reader: true
      option :queries, type: Hash, default: {}
      option :query_proc, reader: true, default: proc { |repository|
        proc do |_name, query, opts|
          query % opts
        end
      }

      attr_reader :connection

      attr_reader :queries

      def initialize(uri, options = {})
        super
        @connection = Sequel.connect(uri, options)
        initialize_queries
        Relation.query_proc(query_proc)
        Relation.load_queries(queries)
      end

      def dataset(_name)
        @dataset ||= Dataset.new(connection)
      end

      def dataset?(_name)
        ! @dataset.nil?
      end

      private

      def initialize_queries
        @queries = options[:queries]

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
