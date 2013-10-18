module VagrantPlugins
  module ProviderIijGp
    module Action
      class MessageInvalidStatus
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vagrant_iijgp.invalid_status", :name => env[:machine].name)
          @app.call(env)
        end
      end
    end
  end
end
