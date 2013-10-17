module VagrantPlugins
  module ProviderIijGp
    module Action
      class StopVirtualMachine
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::stop_virtual_machine")
        end

        def call(env)
          @env = env

          env[:ui].info I18n.t("vagrant.actions.vm.halt.graceful")

          config = env[:machine].provider_config
          gp = config.gp_service_code
          gc = env[:machine].id

          vm = env[:iijapi].gp(gp).gc(gc)
          vm.stop

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_stop")
          vm.wait_for_stop { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
