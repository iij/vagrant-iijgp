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

          config = env[:machine].provider_config
          gp = config.gp_service_code

          if env[:machine].id.nil?
            opts = {
              "VirtualMachineType" => config.virtual_machine_type,
              "OS" => config.os,
              "ContractNum" => "1"
            }
            env[:ui].info "-- AddVirtualMachines option: #{opts}"

            res = env[:iijapi].gp(gp).add_virtual_machines(opts)
            env[:ui].info "-- AddVirtualMachines response: #{res}"
            env[:machine].id = res['GcServiceCodeList'].first
          end

          gc = env[:machine].id
          vm = env[:iijapi].gp(gp).gc(gc)

          vm.wait_while(proc { vm.contract_status! == "InPreparation" }) { env[:ui].info "-- contract status: #{vm.contract_status}" }

          env[:ui].info I18n.t("vagrant_iijgp.import_root_ssh_public_key")
          vm.import_ssh_public_key(config.ssh_public_key)

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_configured")
          vm.wait_while(proc { vm.status! == "Configuring" }) { env[:ui].info "-- current_status: #{vm.status}" }

          @app.call(env)
        end
      end
    end
  end
end
