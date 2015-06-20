case node.platform_family
when 'ubuntu', 'debian'
  package 'apt-transport-https'
  apt_repository 'docker' do
    uri 'https://get.docker.io/ubuntu'
    distribution 'docker'
    components ['main']
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'A88D21E9'
  end
  package 'linux-headers-generic-lts-trusty'
  package 'linux-image-generic-lts-trusty'
  package 'lxc-docker-1.6.0'
  package 'apparmor'
  package 'build-essential'
when 'rhel'
  package 'docker'
  package 'gcc'  
end

service 'docker' do
  action :start
end

ENV['CHEF_DRIVER'] = 'docker'

bash 'build and install chef-provisioning-docker' do
  cwd '/opt/chef-provisioning-docker'
  code <<-EOS
    rm -f chef-provisioning-docker-*.gem
    /opt/chef/embedded/bin/gem build chef-provisioning-docker.gemspec
  EOS
  action :nothing
end.run_action(:run)

chef_gem 'chef-provisioning-docker' do
  source Dir[ '/opt/chef-provisioning-docker/*.gem' ].first
  action :install
end.run_action(:install)

require 'chef/provisioning/docker_driver'
