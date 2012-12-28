# Class: motd
#
# This module manages the /etc/motd file using a template
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  include motd
#
# [Remember: No empty lines between comments and class definition]
class motd {
  if $kernel == "Linux" {
  	if $operatingsystem == "Debian":
	{
	  file { '/etc/motd.tail':
	    owner   => 'root',
	    ensure  => file,
	    group   => 'root',
	    mode    => '0644',
	    content => template('motd/files/motd'),
	  }
        }
	else:
	{
	    file { '/etc/motd':
	      owner   => 'root',
	      ensure  => file,
	      group   => 'root',
	      mode    => '0644',
	      content => template("motd/files/motd"),
	    }
	}
  }
}
