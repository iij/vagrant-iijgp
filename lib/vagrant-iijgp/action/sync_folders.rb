require "vagrant/util/scoped_hash_override"
require "vagrant/util/subprocess"

module VagrantPlugins
  module ProviderIijGp
    module Action
      class SyncFolders
        include Vagrant::Util::ScopedHashOverride

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_iijgp::action::sync_folders")
        end

        def call(env)
          @env = env

          prepare_folders

          @app.call(env)

          install_rsync_guest
          rsync
        end

        def install_rsync_guest
          @env[:ui].info I18n.t("vagrant_iijgp.install_rsync")
          @env[:machine].communicate.execute("yum install -y rsync")
        end

        def rsync
          ssh_info = @env[:machine].ssh_info

          synced_folders.each do |id, data|
            hostpath  = File.expand_path(data[:hostpath], @env[:root_path])
            guestpath = data[:guestpath]

            # append tailing slash for rsync
            hostpath = hostpath + '/' if hostpath !~ /\/$/
            guestpath = guestpath + '/' if guestpath !~ /\/$/

            @env[:machine].communicate.execute(%Q[mkdir -p "#{guestpath}" && chown "#{ssh_info[:username]}" "#{guestpath}"])

            ssh_command = %Q[ssh -p #{ssh_info[:port]} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -i "#{ssh_info[:private_key_path]}"]
            command = %w[rsync -avz --exclude .vagrant/ -e] +
              [ssh_command, hostpath, "#{ssh_info[:username]}@#{ssh_info[:host]}:#{guestpath}"]

            @logger.info ("-- rsync command: #{command.inspect}")
            @env[:ui].info I18n.t("vagrant_iijgp.rsync_folder", :hostpath => hostpath, :guestpath => guestpath)
            ret = Vagrant::Util::Subprocess.execute(*command)
            if ret.exit_code != 0
              raise Errors::RsyncError, :guestpath => guestpath, :hostpath => hostpath, :stderr => ret.stderr
            end
          end
        end

        # Returns an actual list of IIJGP shared folders
        def synced_folders
          {}.tap do |result|
            @env[:machine].config.vm.synced_folders.each do |id, data|
              data = scoped_hash_override(data, :iijgp)

              # Ignore NFS shared folders
              next if data[:nfs]

              # Ignore disabled shared folders
              next if data[:disabled]

              result[id] = data.dup
            end
          end
        end

        # Prepares the synced folders by verifying they exist and creating them
        # if they don't.
        def prepare_folders
          synced_folders.each do |id, options|
            hostpath = Pathname.new(options[:hostpath]).expand_path(@env[:root_path])

            if !hostpath.directory? && options[:create]
              # Host path doesn't exist, so let's create it.
              @logger.debug("Host path doesn't exist, creating: #{hostpath}")

              begin
                hostpath.mkpath
              rescue Errno::EACCES
                raise Vagrant::Errors::SharedFolderCreateFailed,
                  :path => hostpath.to_s
              end
            end
          end
        end
      end
    end
  end
end
