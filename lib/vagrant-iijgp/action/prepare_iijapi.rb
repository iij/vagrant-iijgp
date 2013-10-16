require 'iijapi'

module VagrantPlugins
  module ProviderIijGp
    module Action
      class PrepareIIJAPI
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::prepare_iijapi")
        end

        def call(env)
          config = env[:machine].provider_config

          if env[:machine].id.nil?
            env[:machine].id = config.gc_service_code
          end

          opts = {
            :access_key => config.access_key,
            :secret_key => config.secret_key
          }
          opts[:endpoint] = config.endpoint if config.endpoint

          env[:iijapi] = IIJAPI::GP::Client.new(opts)

          @app.call(env)
        end
      end
    end
  end
end
