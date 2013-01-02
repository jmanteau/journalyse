class kibana::packages {

require ruby::dev

package { 'sinatra':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'json':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'fastercsv':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'tzinfo':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'thin':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'rake':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'rspec':
    ensure   => 'installed',
    provider => 'gem',
}

package { 'rspec-mocks':
    ensure   => 'installed',
    provider => 'gem',
}
}
