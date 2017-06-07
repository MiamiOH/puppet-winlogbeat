# winlogbeat::install
class winlogbeat::install {

  package { $::winlogbeat::winlogbeat_pkg_name:
    ensure   => $::winlogbeat::winlogbeat_pkg_ensure,
    source   => $::winlogbeat::winlogbeat_pkg_source,
    provider => 'chocolatey',
  }
}
