module VagrantPlugins
  module ProviderIijGp
    module Action
      class MessageAlreadyRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info I18n.t("vagrant_iijgp.vm_already_running", :name => env[:machine].name)
          @app.call(env)
        end
      end
    end
  end
end
