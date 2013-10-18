module VagrantPlugins
  module ProviderIijGp
    module Action
      class VagrantTweaks
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::vagrant_tweaks")
        end

        def call(env)
          case env[:machine].provider_config.vagrant_tweaks
          when :allow_root_notty_sudo
            env[:machine].communicate.execute(%q[grep "^Defaults:root !requiretty$" /etc/sudoers ||] +
                                              %q[(chmod 600 /etc/sudoers && sed -i.bak 's/^Defaults\s*requiretty/Defaults requiretty\nDefaults:root !requiretty/g' /etc/sudoers; chmod 400 /etc/sudoers)])
          end

          @app.call(env)
        end
      end
    end
  end
end
