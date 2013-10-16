module VagrantPlugins
  module ProviderIijGp
    module Action
      class SetLabel
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::set_label")
        end

        def call(env)
          config = env[:machine].provider_config
          label = config.label
          gp = config.gp_service_code
          gc = env[:machine].id

          gc = env[:iijapi].gp(gp).gc(gc)

          @logger.info("Setting the label of the VM: #{label}")
          gc.label = label

          @app.call(env)
        end
      end
    end
  end
end
