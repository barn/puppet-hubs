# hubs

class hubs() {

  $gems = [ 'json', 'sanitize' ]

  package { $gems: ensure => installed, provider => gem }

  file { '/usr/local/bin/hubs.rb':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/hubs/hubs.rb',
  }

  cron { 'Cronthehubs':
    command => '/usr/local/bin/hubs.rb >/dev/null 2>&1',
    ensure  => present,
    user    => 'nobody',
    hour    => '*',
    minute  => '*/2',
    require => File['/usr/local/bin/hubs.rb'],
  }

}
