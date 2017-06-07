# winlogbeat::params
class winlogbeat::params {
  $package_ensure    = '5.4.0'
  $version           = undef
  $service_ensure    = running
  $service_enable    = true
  $service_provider  = undef
  $beat_name         = $::fqdn
  $tags              = []
  $queue_size        = 1000
  $max_procs         = undef
  $fields            = {}
  $fields_under_root = false
  $outputs           = {}
  $shipper           = {}
  $logging           = {}
  $run_options       = {}

  if versioncmp('1.9.1', $::rubyversion) > 0 {
    $conf_template = "${module_name}/winlogbeat.yml.ruby18.erb"
  } else {
    $conf_template = "${module_name}/winlogbeat5.yml.erb"
  }

  case $::kernel {
    'windows': {
      $config_file   = undef
      $registry_file = undef
      $tmp_dir       = 'C:/Windows/Temp'
    }

    default: {
      fail("${::kernel} is not supported by winlogbeat.")
    }
  }
}
