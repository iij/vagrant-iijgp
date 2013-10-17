module VagrantPlugins
  module ProviderIijGp
    module Action
      class Boot
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::boot")
        end

        def call(env)
          @env = env

          env[:ui].info I18n.t("vagrant.actions.vm.boot.booting")
          gp = env[:machine].provider_config.gp_service_code
          gc = env[:machine].id

          vm = env[:iijapi].gp(gp).gc(gc)
          vm.start

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_start")
          vm.wait_for_start { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
