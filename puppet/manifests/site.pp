node default {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  Exec { path => [ "/bin/", "/sbin/", "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin"] }

  package { 'wget': ensure => latest }
  package { 'curl': ensure => latest }

  include ntp, git
}

node /^lb\d+\.example\.com$/ {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, nginx
}

node /^app\d+\.example\.com$/ {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, nginx
}

node /^db\d+\.example\.com$/ {
  # Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, postgresql
}
