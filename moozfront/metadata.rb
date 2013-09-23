name             "mooz"
maintainer        "Eric Cestari"
maintainer_email  "ecestari@gmail.com"
license           "Apache 2.0"
description       "Deploys an erlang app (rebar required)"
version           "1.3.3"


recipe "mooz", "Installs moozfront"
recipe "bulkimporter", "Installs bulkimporter"

%w{ ubuntu  }.each do |os|
  supports os
end