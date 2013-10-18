module VagrantPlugins
  module ProviderIijGp
    module Action
      class Destroy
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::destroy")
        end

        def call(env)
          env[:ui].info I18n.t("vagrant_iijgp.initialize_vm")

          gp = env[:machine].provider_config.gp_service_code
          gc = env[:machine].id

          vm = env[:iijapi].gp(gp).gc(gc)
          vm.initialize_vm

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_stop")
          vm.wait_while(proc { vm.status! == "Initializing" }) { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
