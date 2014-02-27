module VagrantPlugins
  module ProviderIijGp
    module Action
      class GcList
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::gc_list")
        end

        def call(env)
          info = env[:describe_virtual_machine_info]
          puts [
                env[:machine].provider_config.gp_service_code,
                info['GcServiceCode'],
                info['VirtualMachineType'],
                info['OS'],
                info['Location'],
                info['GlobalAddress']['IPv4Address'],
                info['PrivateAddress']['IPv4Address'],
                info['Label']
               ].join("\t")

          @app.call(env)
        end

        def show(env, gc)
         end
      end
    end
  end
end
