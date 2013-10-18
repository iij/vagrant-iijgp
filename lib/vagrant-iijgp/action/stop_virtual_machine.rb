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

          force = env[:force_halt] if env.has_key?(:force_halt)
          env[:ui].info I18n.t("vagrant.actions.vm.halt.#{force ? "force" : "graceful"}")

          config = env[:machine].provider_config
          gp = config.gp_service_code
          gc = env[:machine].id

          vm = env[:iijapi].gp(gp).gc(gc)
          vm.stop(force)

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_stop")
          vm.wait_for_stop { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
