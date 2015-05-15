class collectd::plugin::jolokia (
  $ensure   = present,
  $path     = '/opt/collectd-jolokia'
) {

  include collectd::params
  include collectd::plugin::python

  $conf_dir = $collectd::params::plugin_conf_dir

  file { 'collectd-jolokia':
    ensure  => $collectd::plugin::jolokia::ensure,
    path    => $path,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    purge   => true,
    recurse => true,
    force   => true,
    ignore  => ['*.pyc'],
    source  => 'puppet:///modules/collectd/jolokia',
    notify  => Service['collectd']
  }

  concat::fragment { 'collectd.jolokia.header.conf':
    target  => "${conf_dir}/python.conf",
    content => template("collectd/jolokia.header.conf.erb"),
    order   => 6,
  }

  concat::fragment { 'collectd.jolokia.footer.conf':
    target  => "${conf_dir}/python.conf",
    content => template("collectd/jolokia.footer.conf.erb"),
    order   => 8,
  }

  package { 'pyjolokia':
    ensure   => $collectd::plugin::jolokia::ensure,
    notify   => Service['collectd'],
    provider => 'pip',
    require  => Package['python-pip'],
  }

  ensure_packages('python-pip')
}
