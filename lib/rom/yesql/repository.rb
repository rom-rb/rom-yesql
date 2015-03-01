require 'sequel'

require 'rom/yesql/dataset'
require 'rom/yesql/relation'

module ROM
  module Yesql
    class Repository < ROM::Repository
      include Options

      option :path, reader: true

      option :query_proc, reader: true, default: proc { |repository|
        proc do |query, opts|
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
        @queries = Dir["#{path}/*"].each_with_object({}) do |dir, h|
          dataset = File.basename(dir).to_sym
          h[dataset] = {}
          Dir["#{dir}/**/*.sql"].each do |file|
            name = File.basename(file, '.*').to_sym
            sql = File.read(file)
            h[dataset][name] = sql.strip
          end
        end
      end
    end
  end
end
