name             "erlang_app_ow"
maintainer        "Eric Cestari"
maintainer_email  "ecestari@gmail.com"
license           "Apache 2.0"
description       "Deploys an erlang app (rebar required)"
version           "1.3.3"


recipe "erlang_app_ow", "Installs Erlang via native package, source, or Erlang Solutions package"

%w{ ubuntu  }.each do |os|
  supports os
end