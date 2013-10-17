module VagrantPlugins
  module ProviderIijGp
    module Action
      class SetLabel
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::set_label")
        end

        def call(env)
          gp = env[:machine].provider_config.gp_service_code
          gc = env[:machine].id

          vm = env[:iijapi].gp(gp).gc(gc)
          label = env[:machine].provider_config.label || env[:machine].name.to_s || Time.now.strftime('%F %T')

          @logger.info("Setting the label of the VM [#{gp}/#{gc}]: #{label}")
          vm.label = label

          @app.call(env)
        end
      end
    end
  end
end
