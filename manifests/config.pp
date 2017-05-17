# winlogbeat::config
class winlogbeat::config {

  $registry_file = $winlogbeat::registry_file
  $event_logs    = $winlogbeat::event_logs_final

  $winlogbeat_config = {
    'output'     => $winlogbeat::outputs,
    'shipper'    => $winlogbeat::shipper,
    'logging'    => $winlogbeat::logging,
    'runoptions' => $winlogbeat::run_options,
  }

  case $::kernel {
    'Windows' : {
      file {'winlogbeat.yml':
        ensure  => file,
        path    => $winlogbeat::config_file,
        content => template($winlogbeat::conf_template),
        notify  => Service['winlogbeat'],
      }
    } # end Windows

    default : {
      fail($winlogbeat::kernel_fail_message)
    }
  }
}
