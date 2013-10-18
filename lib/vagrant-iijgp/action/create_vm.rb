module VagrantPlugins
  module ProviderIijGp
    module Action
      class CreateVM
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::create_vm")
        end

        def call(env)
          @env = env

          gp = env[:machine].provider_config.gp_service_code
          if env[:machine].id.nil?
            # TODO: AddVirtualMachine
            # env[:machine].id =
          end
          gc = env[:machine].id
          vm = env[:iijapi].gp(gp).gc(gc)

          env[:ui].info I18n.t("vagrant_iijgp.import_root_ssh_public_key")
          vm.import_ssh_public_key(env[:machine].provider_config.ssh_public_key)

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_configured")
          vm.wait_while(proc { vm.status! == "Configuring" }) { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
