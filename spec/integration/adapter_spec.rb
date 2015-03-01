require 'spec_helper'

describe 'ROM / Yesql' do
  include_context 'users and tasks'

  let(:rom) { setup.finalize }

  let!(:setup) do
    ROM.setup(:yesql, [uri, path: path, queries: { reports: report_queries }])
  end

  let(:report_queries) { { all_users: 'SELECT * FROM users ORDER BY %{order}' } }

  let(:users) { rom.relation(:users) }
  let(:tasks) { rom.relation(:tasks) }
  let(:reports) { rom.relation(:reports) }

  before do
    class Users < ROM::Relation[:yesql]
    end

    class Tasks < ROM::Relation[:yesql]
      query_proc(proc { |query, opts| query.gsub(':id:', opts[:id].to_s) })
    end

    class Reports < ROM::Relation[:yesql]
    end
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
  end
end
