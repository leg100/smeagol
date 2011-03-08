#
# Cookbook Name:: ruby
# Recipe:: default
#

DEFAULT_RUBY_VERSION = "1.8.7-p330"

script "installing rvm" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    if [[ ! -d ~/.rvm ]]; then
      bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
    fi
  EOS
end

script "updating rvm to the latest stable version" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    rvm update -—head >> ~/.cinderella/ruby.log 2>&1
  EOS
end

script "installing ruby" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    `rvm list | grep -q '#{DEFAULT_RUBY_VERSION}'`
    if [ $? -ne 0 ]; then
      rvm install #{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

script "ensuring a default ruby is set" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    `which ruby | grep -q rvm`
    if [ $? -ne 0 ]; then
      rvm use #{DEFAULT_RUBY_VERSION} --default
    fi
  EOS
end

template "#{ENV['HOME']}/.rvm/gemsets/default.gems" do
  source "default.gems.erb"
end

# script "ensuring default rubygems are installed" do
#   interpreter "bash"
#   code <<-EOS
#     source ~/.cinderella.profile
#     rvm gemset load ~/.rvm/gemsets/default.gems >> ~/.cinderella/ruby.log 2>&1
#   EOS
# end

execute "cleanup rvm build artifacts" do
  command "find ~/.rvm/src -depth 1 | grep -v src/rvm | xargs rm -rf "
end

template "#{ENV['HOME']}/.gemrc" do
  source "dot.gemrc.erb"
end

template "#{ENV['HOME']}/.rdebugrc" do
    source "dot.rdebugrc.erb"
end

homebrew "rpg"
