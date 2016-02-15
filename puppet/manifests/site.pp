node default {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  Exec { path => [ "/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"] }

  package { 'wget': ensure => latest }
  package { 'curl': ensure => latest }

  include ntp, git
}

node '^lb[0-9]{1,3}.example.com' {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, nginx
}

node '^app[0-9]{1,3}.example.com' {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, nginx
}

node '^db[0-9]{1,3}.example.com' {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, postgresql
}
