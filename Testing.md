Testing Chef Cookbooks:
-----------------------
This repo already comes with all the dependency gems required for testing, such as:

* `chefspec` - for unit testing and TDD (unit testing should test whether messages are sent and recieved correctly)
* `fauxhai` - mocks ohai data for chef testing
* `foodcritic` - linter for chef cookbooks
* `strainer` - sandboxing and isolation tool for cookbooks
* `gaurd` - watches for file changes and trigger tests

End state of the system is tested with acceptance and integration tests

`bundle install` to install all the dependency gems required for testing

###For TDD:

1. Create `spec` dir inside cookbook you are developing
2. Create a `spec_helper.rb` inside `spec` dir, with contents:

    ```
    require 'chefspec'
    ```
3. Create `default_spec.rb` if you have a `default.rb` recipe (similarly `RECIPE_spec.rb` for more specs) and write your tests
4. Also, run `guard` to keep monitoring your recipes and run respective tests. There should be a guard file already configured `Guardfile`

###To check cookbooks against community rules (foodcritic tests):

  ```
  foodcritic cookbooks/COOKBOOK
  #to fail with exit code
  foodcritic -f cookbooks/COOKBOOK
  ```
###Knife tests:

  * validates ruby syntax
  * validates templates

  ```
  knife cookbook test COOKBOOK
  ```

###To simplify all these use `strainer`

  ```
  bundle exec strainer test COOKBOOK_NAME
  ```

##CI
To use jenkins for continous integration at the root of the chef-repo create `script/ci` with following contents

```
set -e
set +x

git submodule update --init 2>&1 > /dev/null
bundle install --quiet
rm -Rf .colander
strainer test `echo $JOB_NAME | sed 's/_cookbook//'`
```

Adding Data bags to chefspec:

```
require 'chef_spec'

describe 'hostsfile::default' do
  let(:hosts) { ['1.2.3.4 example.com', '4.5.6.7 bar.com'] }

  before do
    Chef::Recipe.any_instance.stub(:data_bag).with('etc_hosts').and_return(hosts)
  end

  let(:runner) { ChefSpec::ChefRunner.new.converge('hostsfile::default') }

  it 'loads the data bag' do
    Chef::Recipe.any_instance.should_recieve(:data_bag).with('etc_hosts')
  end

  it 'creates the /etc/hosts template' do
    expect(runner).to create_template('/etc/hosts').with_content(hosts.join("\n"))
  end
end
```