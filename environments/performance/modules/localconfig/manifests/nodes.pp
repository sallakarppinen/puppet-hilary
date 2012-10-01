node 'app0' inherits appnode {
  
  package { 'gcc-compiler':
    ensure   => present,
    provider => pkgin,
  }
  
  $node_version = $localconfig::node_version
  $node_dl = "/tmp/node-v$node_version.tar.gz"
  $node_root = '/opt/node'
  $node_dir = "$node_root/${localconfig::node_version}"
  
  file { "${node_root}":
    ensure => 'directory',
    owner =>  $localconfig::user,
    group =>  $localconfig::group,
    mode  =>  755,
  }
  
  exec { "node_${node_version}_wget":
    command => "/usr/bin/wget http://nodejs.org/dist/v${node_version}/node-v${node_version}.tar.gz -O ${node_dl}",
    unless  => "test -f $node_dir"
  }
  
  exec { "node_${node_version}_extract":
    cwd     => "/tmp",
    command => "/opt/local/bin/tar -zxvf ${node_dl}",
  }
    
    
}