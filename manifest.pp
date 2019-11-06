class { 'ffnord::params':
  router_id => "10.187.130.1",  # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65187",            # The as of the providing community
  wan_devices => ['eth0'],        # An array of devices which should be in the wan zone

  wmem_default => 87380,          # Define the default socket send buffer
  wmem_max     => 12582912,       # Define the maximum socket send buffer
  rmem_default => 87380,          # Define the default socket recv buffer
  rmem_max     => 12582912,       # Define the maximum socket recv buffer
  
  gw_control_ips => "8.8.8.8", # Define target to ping against for function check

  max_backlog  => 5000,           # Define the maximum packages in buffer
  include_bird4 => false,
  maintenance => 0,
  
  batman_version => 15,            # B.A.T.M.A.N. adv version
}
# aus https://github.com/ffnord/site-nord/blob/master/site.conf
# und https://github.com/freifunk/icvpn-meta/blob/master/nord
ffnord::mesh { 'mesh_ffnord':
    mesh_name => "Freifunk Kreis Dithmarschen"
  , mesh_code => "ffnord-he"
  , mesh_as => "65187"
  , mesh_mac  => "de:dd:be:ef:ff:00"
  , vpn_mac  => "de:dd:be:ff:ff:00"
  , mesh_ipv6 => "fd42:eb49:c0b5:4242::fe00/64"
  , mesh_ipv4  => "10.187.130.1/17"
  , range_ipv4 => "10.187.0.0/16"
  , mesh_mtu     => "1312"
  , mesh_peerings    => "/opt/nord-hei-puppet-config/mesh_peerings.yaml"
  
  , fastd_secret => "/root/nord-hei-gw00-fastd-secret.key"
  , fastd_port   => 10050
  , fastd_peers_git => 'https://github.com/Freifunk-hei/nord-hei-gw-peers.git'
  , fastd_verify=> 'true'                               # set this to 'true' to accept all fastd keys without verification
  
  , dhcp_ranges => ['10.187.130.2 10.187.135.254'] 
  , dns_servers => ['10.187.130.1']               # should be the same as $router_id
}

class {'ffnord::vpn::provider::hideio':
  openvpn_server => "$$$",
  openvpn_port   => 3478,
  openvpn_user   => "$$$",
  openvpn_password => "$$$";
}

ffnord::named::zone {
  "nord": zone_git => "https://github.com/Freifunk-hei/nord-hei-zone.git", exclude_meta => 'nord';
}

class {
  ['ffnord::etckeeper','ffnord::rsyslog','ffnord::mosh']:
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig','unattended-upgrades','tmux','sshguard']:
     ensure => installed;
}
