require_relative 'spec_helper'

# default recipe
describe 'tmux::default' do
  # let does lazzy loading
  let(:runner) {
    # create new chef runner on tmux cookbook and default recipe
    # ChefSpec::ChefRunner.new.converge('tmux::default')

    # or converge a new node with platform using fauxhai
    ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge('tmux::default')
  }

  it 'installs the tmux package' do
    expect(runner).to install_package('tmux')
  end

  it 'creates the tmux.conf file' do
    expect(runner).to create_file_with_content('/etc/tmux.conf', 'set -g prefix C-a')
  end
end