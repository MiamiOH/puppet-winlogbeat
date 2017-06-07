# winlogbeat::install
class winlogbeat::install {

  package { 'winlogbeat':
    ensure   => $winlogbeat::package_ensure,
    provider => chocolatey,
  }
}
