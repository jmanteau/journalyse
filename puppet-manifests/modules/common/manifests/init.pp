# common/manifests/init.pp - Define common infrastructure for modules
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

import "defines/*.pp"
# Pas de classe pour le moment
#import "classes/*.pp"

class common {
}

# pour ajouter les defines line.pp et replace.pp de maniere generique
include common
