module VagrantPlugins
  module ProviderIijGp
    module Action
      class ReadState
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::read_state")
        end

        def to_snake_sym(str)
          str.gsub(/[A-Z]/) {|s| "_#{s.downcase}" }.sub(/^_/, '').to_sym
        end

        def call(env)
          env[:machine_state] = read_state(env)
          @app.call(env)
        end

        def read_state(env)
          machine = env[:machine]
          return :not_created if machine.id.nil?

          vm = env[:iijapi].gp(machine.provider_config.gp_service_code).gc(machine.id)
          if contract_status = vm.contract_status
            if contract_status == "InService"
              return to_snake_sym(vm.status)
            elsif contract_status == "InPreparation"
              return :in_preparation
            else
              machine.id = nil
              return :not_created
            end
          else
            machine.id = nil
            return :not_created
          end
        end
      end
    end
  end
end
