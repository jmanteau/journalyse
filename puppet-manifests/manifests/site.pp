class baseclass {
    include base
}

class central-syslog {
    include baseclass

   include centralrsyslog

}


node default {
    include baseclass
    include central-syslog
}
