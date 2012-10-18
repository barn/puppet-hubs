# hubs

class hubs() {

  $gems = [ 'json', 'httparty', 'irckitten', 'sanitize' ]

  package { $gems: ensure => installed, provider => gem }

  file { '/usr/local/bin/hubs.rb':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/hubs/hubs.rb',
  }

  cron { '/usr/local/bin/hubs.rb':
    ensure  => present,
    user    => 'nobody',
    hour    => '*',
    minute  => '*/2',
    require => File['/usr/local/bin/hubs.rb'],
  }

}
