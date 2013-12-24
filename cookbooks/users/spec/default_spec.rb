require 'chefspec'

describe 'users::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'users::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
