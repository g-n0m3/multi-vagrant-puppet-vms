node default {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git
}

node 'lb1.example.com', 'app1.example.com', 'db1.example.com' {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include ntp, git, docker, fig
}