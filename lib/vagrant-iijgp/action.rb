require "vagrant/action/builder"

module VagrantPlugins
  module ProviderIijGp
    module Action
      include Vagrant::Action::Builtin

      def self.action_boot
        Vagrant::Action::Builder.new.tap do |b|
          b.use Provision
          b.use SyncFolders
          b.use SetLabel
          b.use Boot
          b.use WaitForCommunicator, [:starting, :running]
        end
      end

      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, IsCreated do |env1, b1|
            if !env1[:result]
              b1.use MessageNotCreated
              next
            end

            b1.use Call, DestroyConfirm do |env2, b2|
              if env2[:result]
                b2.use EnvSet, :force_halt => true
                b2.use action_halt
                b2.use Destroy
                b2.use ProvisionerCleanup
              else
                b2.use MessageWillNotDestroy
              end
            end
          end
        end
      end

      def self.action_halt
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use Call, IsCreated do |env1, b1|
            if env1[:result]
              b1.use Call, IsStopped do |env2, b2|
                if !env2[:result]
                  b2.use StopVirtualMachine
                end
              end
            else
              b1.use MessageNotCreated
            end
          end
        end
      end

      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use Call, ReadState do |env1, b1|
            case env1[:machine_state]
            when :running
              b1.use Provision
              b1.use SyncFolders
              b1.use VagrantTweaks
            when :not_created, :initialized
              b1.use MessageNotCreated
            else
              b1.use MessageInvalidStatus
            end
          end
        end
      end

      def self.action_reload
      end

      def self.action_read_ssh_info
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use ReadSSHInfo
        end
      end

      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use ReadState
        end
      end

      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use CheckRunning
          b.use SSHExec
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use CheckRunning
          b.use SSHRun
        end
      end

      def self.action_start
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, IsStopped do |env1, b1|
            if env1[:result]
              b1.use action_boot
            else
              b1.use MessageAlreadyRunning
              next
            end
          end
        end
      end

      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use PrepareIIJAPI
          b.use Call, ReadState do |env1, b1|
            case env1[:machine_state]
            when :not_created, :initialized
              b1.use CreateVM
              b1.use action_start
              b1.use VagrantTweaks
            when :stopped
              b1.use action_start
            when :running
              b1.use MessageAlreadyRunning
            else
              b1.use MessageInvalidStatus
            end
          end
        end
      end

      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :Boot, action_root.join("boot")
      autoload :CheckRunning, action_root.join("check_running")
      autoload :CreateVM, action_root.join("create_vm")
      autoload :Destroy, action_root.join("destroy")
      autoload :IsCreated, action_root.join("is_created")
      autoload :IsStopped, action_root.join("is_stopped")
      autoload :MessageAlreadyRunning, action_root.join("message_already_running")
      autoload :MessageInvalidStatus, action_root.join("message_invalid_status")
      autoload :MessageNotCreated, action_root.join("message_not_created")
      autoload :MessageWillNotDestroy, action_root.join("message_will_not_destroy")
      autoload :PrepareIIJAPI, action_root.join("prepare_iijapi")
      autoload :ReadSSHInfo, action_root.join("read_ssh_info")
      autoload :ReadState, action_root.join("read_state")
      autoload :SetLabel, action_root.join("set_label")
      autoload :StopVirtualMachine, action_root.join("stop_virtual_machine")
      autoload :SyncFolders, action_root.join("sync_folders")
      autoload :VagrantTweaks, action_root.join("vagrant_tweaks")

    end
  end
end
