source "https://rubygems.org"

# Ensure github repositories are fetched using HTTPS
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  puts(repo_name)
  "https://github.com/#{repo_name}.git"
end if Gem::Version.new(Bundler::VERSION) < Gem::Version.new('2')

gem 'cocoapods', "1.4.0"
gem 'generamba', github: 'surfstudio/Generamba', branch: 'develop', :ref => '91957270f4bc0092305ce6dbf016be5259720d33'