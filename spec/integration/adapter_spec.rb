require 'spec_helper'

describe 'ROM / Yesql' do
  include_context 'users'

  subject(:users) { rom.relation(:users) }

  let(:rom) { setup.finalize }
  let(:setup) { ROM.setup(:yesql, [uri, path: path]) }

  before do
    setup.relation(:users, adapter: :yesql)
  end

  it 'works yay!' do
    expect(users.by_name(name: 'Jane')).to match_array([{ id: 1, name: 'Jane' }])
  end
end
