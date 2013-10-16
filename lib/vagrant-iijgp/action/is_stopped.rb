module VagrantPlugins
  module ProviderIijGp
    module Action
      class IsStopped
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state.id == :stopped
          @app.call(env)
        end
      end
    end
  end
end
