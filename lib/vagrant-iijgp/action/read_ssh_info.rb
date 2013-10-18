module VagrantPlugins
  module ProviderIijGp
    module Action
      class ReadSSHInfo
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::read_ssh_info")
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:iijapi], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(cli, machine)
          vm = cli.gp(machine.provider_config.gp_service_code).gc(machine.id)

          {
            :host => vm.info['GlobalAddress']['IPv4Address'],
            :port => 22
          }
        end
      end
    end
  end
end
