name             "mooz"
maintainer        "Eric Cestari"
maintainer_email  "ecestari@gmail.com"
license           "Apache 2.0"
description       "Deploys an erlang app (rebar required)"
version           "1.3.3"


recipe "moozfront::default", "Installs moozfront"
recipe "moozfront::bulkimporter", "Installs bulkimporter"

depends "s3_file"

%w{ ubuntu  }.each do |os|
  supports os
end