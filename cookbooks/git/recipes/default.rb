#
# Cookbook Name:: git
# Recipe:: default
#
root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))
require root + '/resources/homebrew'
require root + '/providers/homebrew'
require 'etc'

current_user = node[:current_user].to_sym

template "#{ENV['HOME']}/.gitconfig" do
  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.gitconfig.erb"
  variables({
    :home         => ENV['HOME'],
    :user         => ENV['USER'],
    :email        => ENV['EMAIL'] || node[:email],
    :github_user  => ENV['GITHUB_USER'] || node[:github_user],
    :github_token => ENV['GITHUB_TOKEN'] || node[:github_token],
    :editor       => ENV['EDITOR']   || fail("No editor set for your ~/.gitconfig"),
    :fullname     => ENV['FULLNAME'] || node[:etc][:passwd][current_user][:gecos] || fail("No Full Name set for your ~/.gitconfig")
  })
end
