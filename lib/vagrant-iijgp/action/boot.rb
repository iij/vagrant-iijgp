module VagrantPlugins
  module ProviderIijGp
    module Action
      class Boot
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::boot")
        end

        def call(env)
          @env = env

          env[:ui].info I18n.t("vagrant.actions.vm.boot.booting")
          gc = env[:iijapi].gp(@gp_service_code).gc(@gc_service_code)
          gc.start

          env[:ui].info I18n.t("vagrant_iijgp.wait_for_start")
          gc.wait_for_start { env[:ui].info "-- current_status: #{gc.status}" }

          raise Vagrant::Errors::VMFailedToBoot if !wait_for_boot(gc)

          @app.call(env)
        end

        def wait_for_boot
          @env[:ui].info I18n.t("vagrant.actions.vm.boot.waiting")

          @env[:machine].config.ssh.max_tries.to_i.tomes do |i|
            if @env[:machine].communicate.ready?
              @env[:ui].info I18n.t("vagrant.actions.vm.boot.ready")
              return true
            end

            # Return true so that the vm_failed_to_boot error doesn't
            # get shown
            return true if @env[:interrupted]

            # # If the VM is not starting or running, something went wrong
            # # and we need to show a useful error.
            # state = @env[:machine].provider.state.id
            # raise Vagrant::Errors::VMFailedToRun if state != :starting && state != :running

            sleep 2 if !@env["vagrant.test"]
          end

          @env[:ui].error I18n.t("vagrant.actions.vm.boot.failed")
          false
        end
      end
    end
  end
end
