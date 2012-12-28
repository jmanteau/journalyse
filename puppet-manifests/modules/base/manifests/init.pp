# module de base pour tous les OS

# fonction pour tout le monde

class base {


        case $operatingsystem {
                Debian:  { include base::debian }
        }
	
}

# fonction pour les debian
# definition de la classe qui recoupe les fichiers presents pour 
# toutes les debian
class base::debian {

	# soft
	package { 
	  	"bind9-host":        ensure => installed;
	  	"dnsutils":          ensure => installed;
	  	"htop":              ensure => installed;
        	"libshadow-ruby1.8": ensure => installed;
        	"lsb-release":       ensure => installed;
	  	"screen":            ensure => installed;
		"tcpdump":           ensure => installed;
	  	"telnet":            ensure => installed;
		"vim":               ensure => installed;
		"unzip":               ensure => installed;
	}

}

