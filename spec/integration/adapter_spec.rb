require 'spec_helper'

describe 'ROM / Yesql' do
  include_context 'users'

  it 'works yay!' do
    class Queries < ROM::Relation[:yesql]
    end

    queries = rom.relations[:queries]

    expect(queries.by_name(name: 'Jane').to_a).to eql([{ id: 1, name: 'Jane' }])
  end
end
