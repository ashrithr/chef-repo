guard :rspec, spec_paths: ['spec', 'cookbooks/*/spec'] do
  watch(%r{^spec/.+_spec\.rb$})

  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^cookbooks/(.+)/recipes/(.+)\.rb$}) do |m|
    "cookbooks/#{m[1]}/spec/#{m[2]}_spec.rb"
  end

  watch(%r{^cookbooks/([A-Za-z]+)/(.+)(\..*)$}) do |m|
    "cookbooks/#{m[1]}/spec/*.rb"
  end

end

