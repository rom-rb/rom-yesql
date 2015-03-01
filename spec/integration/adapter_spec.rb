require 'spec_helper'

describe 'ROM / Yesql' do
  include_context 'users and tasks'

  let(:rom) { setup.finalize }

  let!(:setup) do
    ROM.setup(:yesql, [uri, path: path])
  end

  let(:users) { rom.relation(:users) }
  let(:tasks) { rom.relation(:tasks) }

  before do
    class Users < ROM::Relation[:yesql]
    end

    class Tasks < ROM::Relation[:yesql]
      query_proc(proc { |query, opts| query.gsub(':id:', opts[:id].to_s) })
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
  end
end
