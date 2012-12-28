# Class: passenger::params
#
# This class manages parameters for the Passenger module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class passenger::params {
  $passenger_version = '3.0.9'
  $passenger_ruby = '/usr/bin/ruby'
  $passenger_provider = 'gem'
  $rubygems_version= '1.9.1'

  case $::osfamily {
    'debian': {
      $passenger_package = 'passenger'
      $gem_path = "/var/lib/gems/${rubygems_version}/gems"
      $gem_binary_path = "/var/lib/gems/${rubygems_version}/bin"
      $mod_passenger_location = "/var/lib/gems/${rubygems_version}/gems/passenger-$passenger_version/ext/apache2/mod_passenger.so"

# Ubuntu does not have libopenssl-ruby - it's packaged in libruby
      if $::lsbdistid == 'Ubuntu' {
        $libruby = 'libruby'
      } else {
        $libruby = 'libopenssl-ruby'
      }
    }
    'redhat': {
      $passenger_package = 'passenger'
      $gem_path = "/usr/lib/ruby/gems/${rubygems_version}/gems"
      $gem_binary_path = "/usr/lib/ruby/gems/${rubygems_version}/gems/bin"
      $mod_passenger_location = "/usr/lib/ruby/gems/${rubygems_version}/gems/passenger-$passenger_version/ext/apache2/mod_passenger.so"
    }
    'darwin':{
      $passenger_package = 'passenger'
      $gem_path = '/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin'
      $gem_binary_path = '/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin'
      $mod_passenger_location = "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/passenger-$passenger_version/ext/apache2/mod_passenger.so"
    }
    default: {
      fail("Operating system ${::operatingsystem} is not supported with the Passenger module")
    }
  }
}
