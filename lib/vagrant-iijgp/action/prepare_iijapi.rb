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

          # use the existing gc contract.
          if config.gc_service_code
            if env[:machine].id.nil?
              # first time `vagrant up`
              env[:machine].id = config.gc_service_code
            elsif config.gc_service_code != env[:machine].id
              raise Errors::MismatchServiceCode, :provider_config => config.gc_service_code, :machine_id => env[:machine].id
            end
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
