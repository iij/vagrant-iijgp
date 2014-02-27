module VagrantPlugins
  module ProviderIijGp
    module Action
      class DescribeVirtualMachine
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::describe_virtual_machine")
        end

        def call(env)
          env[:describe_virtual_machine_info] = read_info(env[:iijapi], env[:machine])

          @app.call(env)
        end

        def read_info(cli, machine)
          cli.gp(machine.provider_config.gp_service_code).gc(machine.id).info
        end
      end
    end
  end
end
