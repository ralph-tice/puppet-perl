require 'puppet/util/execution'

Puppet::Type.type(:plenv_cpanm).provide(:cpan) do
  include Puppet::Util::Execution
  desc ""

  def path
    [
      "#{@resource[:plenv_root]}/bin",
      "#{@resource[:plenv_root]}/shims",
      "#{Factor[:boxen_home].value}/homebrew/bin",
    ].join(':')
  end

  def plenv_command(command)
    full_command = [
      "sudo -u #{Factor[:luser].value}",
      "PATH=#{path}",
      "PLENV_VERSION=#{@resource[:plenv_version]}",
      "PLENV_HOME=#{@resource[:plenv_root]}",
      "#{@resource[:plenv_root]}/bin/plenv exec #{command}",
    ]

    [ output, $? ]
  end

  def create
    plenv_command "cpanm #{@resource[:cpan]}"
  end

  def destory 
    plenv_command "pm-uninstall #{@resource[:cpan]}"
  end

  def exists?
    ret = plenv_command "perl -M#{@resource[:cpan]} -e 'exit 0'"
    return ( ret[0] == 0 ) ? true : false ;
  end

end




