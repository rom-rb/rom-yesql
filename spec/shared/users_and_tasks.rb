RSpec.shared_context 'users and tasks' do
  include_context 'database setup'

  before do
    conn[:users].insert id: 1, name: 'Jane'
    conn[:users].insert id: 2, name: 'Joe'
    conn[:users].insert id: 3, name: 'Jade'

    conn[:tasks].insert id: 1, title: 'Task One'
    conn[:tasks].insert id: 2, title: 'Task Two'
  end
end
