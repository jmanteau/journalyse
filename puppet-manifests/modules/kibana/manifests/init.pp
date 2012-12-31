class kibana($elasticsearch_server ='localhost:9200') {

	require packages	

	$documentroot = $operatingsystem ?{
		debian  => "/var/www",
		ubuntu  => "/var/www",
		suse    => "/srv/www",
		redhat    => "/srv/www",
		default => "/var/www/html",
	}

	$kibanadir = "${documentroot}/kibana"

	class { 'apache::mod::passenger': }	

	apache::vhost { 'kibana':
		vhost_name      => $hostname,
		port            => '80',
		docroot         => "${kibanadir}/static",
	}



	netinstall { kibana :
		url => "https://github.com/rashidkpc/Kibana/archive/kibana-ruby.zip",
		destination_dir => $documentroot,
		extracted_dir => "Kibana-kibana-ruby",
		preextract_command => "rm -rf ${kibanadir}",
		postextract_command => "mv ${documentroot}/Kibana-kibana-ruby ${kibanadir}",
	}

	file { "${kibanadir}/KibanaConfig.rb":
		require => Netinstall[kibana],
		ensure  => 'file',
		group   => $apache::params::group,
		mode    => '0664',
		owner   => $apache::params::owner,
		content => template('kibana/KibanaConfig.rb.erb'),
	}
	file { $kibanadir:
		require => Netinstall[kibana],
		ensure => directory, # so make this a directory
		recurse => true, # enable recursive directory management
		group   => $apache::params::group,
		mode    => '0664',
		owner   => $apache::params::owner,
	}

}
