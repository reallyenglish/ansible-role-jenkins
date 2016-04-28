require 'spec_helper'
require 'serverspec'

# XXX wait here for jenkins finishes reload
sleep 20

jenkins_package_name = 'jenkins'
jenkins_service_name = 'jenkins'
jenkins_user_name    = 'jenkins'
jenkins_user_group   = 'jenkins'
jenkins_cli         = '/opt/jenkins-cli.jar -s http://localhost:8080/'

case os[:family]
when 'freebsd'
  jenkins_cli         = 'java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080/'
end

describe package(jenkins_package_name) do
  it { should be_installed }
end 

describe service(jenkins_service_name) do
  it { should be_running }
  it { should be_enabled }
end


describe port(8080) do
  it { should be_listening }
end

describe command("#{jenkins_cli} list-plugins") do
  its(:stdout) { should match /^git\s+/ }
  its(:stdout) { should match /^sonar\s+/ }
  its(:stdout) { should match /^ssh\s+/ }
  its(:stderr) { should match /^$/ }
end
