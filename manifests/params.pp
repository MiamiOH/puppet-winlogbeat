# winlogbeat::params
class winlogbeat::params {
  $service_ensure = running
  $service_enable = true
  $outputs        = {}
  $shipper        = {}
  $logging        = {}
  $run_options    = {}

  if versioncmp('1.9.1', $::rubyversion) > 0 {
    $conf_template = "${module_name}/winlogbeat.yml.ruby18.erb"
  } else {
    $conf_template = "${module_name}/winlogbeat.yml.erb"
  }

  case $::kernel {
    'windows' : {
      $winlogbeat_pkg_name    = 'winlogbeat'
      $winlogbeat_pkg_ensure  = '5.4.0'
      $winlogbeat_pkg_version = $winlogbeat_pkg_ensure
      $winlogbeat_pkg_source  = undef
      $config_file      = "C:/ProgramData/chocolatey/lib/winlogbeat/tools/winlogbeat-${winlogbeat_pkg_version}-windows-x86_64/winlogbeat.yml"
      $registry_file    = "C:/ProgramData/chocolatey/lib/winlogbeat/tools/winlogbeat-${winlogbeat_pkg_version}-windows-x86_64/.winlogbeat.yml"
      $tmp_dir          = 'C:/Windows/Temp'
      $service_provider = undef

    }

    default : {
      fail("${::kernel} is not supported by winlogbeat.")
    }
  }
}
