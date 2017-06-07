# This class installs the Elastic winlogbeat log shipper and
# helps manage which logs are shipped
#
# @example
# class { 'winlogbeat':
#   outputs => {
#     'logstash' => {
#       'hosts' => [
#         'localhost:5044',
#       ],
#     },
#   },
# }
#
# @param service_ensure [String] The ensure parameter on the winlogbeat service (default: running)
# @param service_enable [String] The enable parameter on the winlogbeat service (default: true)
# @param registry_file [String] The registry file used to store positions, absolute or relative to working directory (default .winlogbeat.yml)
# @param conf_template [String] The configuration template to use to generate the main winlogbeat.yml config file
# @param outputs [Hash] Will be converted to YAML for the required outputs section of the winlogbeat config
# @param shipper [Hash] Will be converted to YAML to create the optional shipper section of the winlogbeat config
# @param logging [Hash] Will be converted to YAML to create the optional logging section of the winlogbeat config
# @param tmp_dir [String] Where winlogbeat should be temporarily downloaded to so it can be installed
# @param event_logs [Hash] Event_logs that will be forwarded.
# @param event_logs_merge [Boolean] Whether $event_logs should merge all hiera sources, or use simple automatic parameter lookup

class winlogbeat (
  $package_ensure    = $winlogbeat::params::package_ensure,
  $version           = $winlogbeat::params::version,
  $service_ensure    = $winlogbeat::params::service_ensure,
  $service_enable    = $winlogbeat::params::service_enable,
  $service_provider  = $winlogbeat::params::service_provider,
  $registry_file     = $winlogbeat::params::registry_file,
  $config_file       = $winlogbeat::params::config_file,
  $conf_template     = $winlogbeat::params::conf_template,
  $outputs           = $winlogbeat::params::outputs,
  $shipper           = $winlogbeat::params::shipper,
  $logging           = $winlogbeat::params::logging,
  $run_options       = $winlogbeat::params::run_options,
  $tmp_dir           = $winlogbeat::params::tmp_dir,
  $beat_name         = $winlogbeat::params::beat_name,
  $tags              = $winlogbeat::params::tags,
  $queue_size        = $winlogbeat::params::queue_size,
  $max_procs         = $winlogbeat::params::max_procs,
  $fields            = $winlogbeat::params::fields,
  $fields_under_root = $winlogbeat::params::fields_under_root,
  $metrics           = undef,
  $event_logs        = [],
  $event_logs_merge  = false,
) inherits winlogbeat::params {

  validate_bool($event_logs_merge)

  $real_version = $version ? {
    undef   => $package_ensure,
    default => $version,
  }
  $real_registry_file = $registry_file ? {
    undef   => "C:/ProgramData/chocolatey/lib/winlogbeat/tools/winlogbeat-${real_version}-windows-x86_64/.winlogbeat.yml",
    default => $registry_file,
  }
  $real_config_file = $config_file ? {
    undef   => "C:/ProgramData/chocolatey/lib/winlogbeat/tools/winlogbeat-${real_version}-windows-x86_64/winlogbeat.yml",
    default => $config_file,
  }

  if $event_logs_merge {
    $event_logs_final = hiera_array('winlogbeat::event_logs', $event_logs)
  } else {
    $event_logs_final = $event_logs
  }

  validate_hash($outputs, $logging)
  validate_array($event_logs_final)
  validate_string($registry_file, $package_ensure)

  anchor { 'winlogbeat::begin': } ->
  class { 'winlogbeat::install': } ->
  class { 'winlogbeat::config': } ->
  class { 'winlogbeat::service': } ->
  anchor { 'winlogbeat::end': }
}
