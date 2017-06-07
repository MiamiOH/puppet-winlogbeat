# winlogbeat::config
class winlogbeat::config {

  $winlogbeat_config = delete_undef_values({
    'beat_name'         => $winlogbeat::beat_name,
    'tags'              => $winlogbeat::tags,
    'queue_size'        => $winlogbeat::queue_size,
    'max_procs'         => $winlogbeat::max_procs,
    'fields'            => $winlogbeat::fields,
    'fields_under_root' => $winlogbeat::fields_under_root,
    'winlogbeat'        => {
      'registry_file' => $winlogbeat::real_registry_file,
      'metrics'       => $winlogbeat::metrics,
      'event_logs'    => $winlogbeat::event_logs_final,
    },
    'output'            => $winlogbeat::outputs,
    'shipper'           => $winlogbeat::shipper,
    'logging'           => $winlogbeat::logging,
    'runoptions'        => $winlogbeat::run_options,
  })

  file { 'winlogbeat.yml':
    ensure  => file,
    path    => $winlogbeat::real_config_file,
    content => template($winlogbeat::conf_template),
    notify  => Service['winlogbeat'],
  }
}
