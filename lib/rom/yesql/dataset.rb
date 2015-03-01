module ROM
  module Yesql
    class Dataset
      attr_reader :connection

      def initialize(connection)
        @connection = connection
      end

      def read(query)
        connection.fetch(query)
      end
    end
  end
end
