class centralrsyslog{


        file { "/etc/logrotate.d/remote":
                ensure  => 'file',
                group   => 0,
                mode    => '0664',
                owner   => 0,
                content => template('centralrsyslog/remote')
        }


class { 'rsyslog::server':
        enable_tcp                => true,
        enable_udp                => true,
        enable_onefile            => true,
	custom_config             => "rsyslog/centralserver.conf.erb",
        server_dir                => '/var/log/remote/',
    }

class { 'logstash::config':
  logstash_home          => '/opt/logstash',
  logstash_jar_provider  => 'http',             # pull down the jar over http
  elasticsearch_provider => 'embedded',         # we'll run ES inside out logstash JVM
  java_provider          => 'package',          # install java for me please, from a package
  java_package           => 'openjdk-6-jdk',    # package name on this platform
  java_home              => '/usr/lib/jvm/java-6-openjdk-amd64',
}
    class { 'logstash::indexer': }

    include kibana

}
