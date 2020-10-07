require 'spec_helper'

RSpec.describe 'ROM / Yesql' do
  include_context 'users and tasks'

  let(:container) { ROM.container(configuration) }

  let!(:configuration) do
    ROM::Configuration.new(:yesql, [uri, path: path, queries: { reports: report_queries }])
  end

  let(:report_queries) { { all_users: 'SELECT * FROM users ORDER BY %{order}' } }

  let(:users) { container.relations[:users] }
  let(:tasks) { container.relations[:tasks] }
  let(:reports) { container.relations[:reports] }

  before do
    configuration.relation(:users)
    configuration.relation(:tasks) do
      query_proc(proc { |_name, query, opts| query.gsub(':id:', opts[:id].to_s) })
    end

    module Test
      class Reports < ROM::Relation[:yesql]
        dataset :reports
      end
    end

    configuration.register_relation(Test::Reports)
  end

  describe 'query method' do
    it 'uses hash-based interpolation by default' do
      expect(users.by_name(name: 'Jane')).to match_array([
        { id: 1, name: 'Jane' }
      ])
    end

    it 'uses provided proc to preprocess a query' do
      expect(tasks.by_id(id: 1)).to match_array([
        { id: 1, title: 'Task One' }
      ])
    end

    it 'uses queries provided explicitly during setup' do
      expect(reports.all_users(order: 'name').to_a).to eql([
        { id: 3, name: 'Jade' },
        { id: 1, name: 'Jane' },
        { id: 2, name: 'Joe' }
      ])
    end

    it 'returns rom relation' do
      relation = users.by_name(name: 'Jane') >> proc { |r| r.map { |t| t[:name] } }
      expect(relation).to match_array(['Jane'])
    end
  end
end
