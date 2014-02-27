# Vagrant IIJ GIO Provider

これは [Vagrant](http://www.vagrantup.com) 1.3+ に IIJ GIO ホスティングパッケージサービスの
仮想サーバを操作する機能を追加する provider です。

## Features

-   IIJ GIO ホスティングパッケージサービスの仮想マシンを起動することができます
-   仮想サーバに SSH ログインができます
-   Chef による仮想サーバの provisioning ができます
-   `rsync` を用いた synced folder をサポートしています
-   IIJ CentOS イメージに対して、いくつかの調整を行ないます
    -   root ユーザに対する sudo の `Default requiretty` 設定を無効化します

## Usage

通常の Vagrant 1.1+ 以降のプラグインの導入方法と同様にインストールできます。
インストール後は、`iijgp` provider を指定して `vagrant up` してください。
以下に例を示します

~~~~ {.shell}
$ vagrant plugin install vagrant-iijgp
...
$ vagrant up --provider=iijgp
...
~~~~

上記を実行する前に、iijgp 用の Vagrant box を入手しておく必要があります。

## Quick Start

プラグインを(前述の通り)インストールした後、
手っ取り早く始めるには、ダミーの IIJGP box を使い、
詳しいパラメータは `config.vm.provider` ブロックに都度指定する方法があります。
まず、はじめにダミーの box を任意の名前で追加します:

~~~~ {.shell}
$ vagrant box add dummy https://github.com/iij/vagrant-iijgp/raw/master/dummy.box
....
~~~~

次に、Vagrantfile を以下のように作成し、必要な情報を埋めてください。

~~~~ {.ruby}
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :iijgp do |iijgp, override|
    iijgp.access_key = "YOUR ACCESS KEY"
    iijgp.secret_key = "YOUR SECRET KEY"
    iijgp.gp_service_code = "gpXXXXXXXX"
    iijgp.ssh_public_key = "YOUR PUBLIC SSH KEY"

    override.ssh.username = "root"
    override.ssh.private_key_path = "#{ENV['HOME']}/.ssh/id_rsa"
  end

  config.vm.define "vm1" do |c|
    c.vm.provider :iijgp do |iijgp|
      iijgp.gc_service_code = "gcXXXXXXXX"
    end
  end
end
~~~~

そして `vagrant up --provider=iijgp vm1` を実行してください。

これは、既に GP "gpXXXXXXXX" 内に作成済みの "gcXXXXXXXX" を起動します。
また、SSH 用の情報が正しく Vagrantfile に設定されていれば、
SSH と provisioning が行なわれます。

もし、あなたが iijgp provider をデフォルトで利用したい場合、
以下のようにシェルを設定することで、`vagrant up` だけで iijgp provider が利用できます。
~~~~ {.shell}
export VAGRANT_DEFAULT_PROVIDER=iijgp
~~~~

## Commands

-   `gc-list`:
    Vagrantfile 内で設定されている仮想サーバの一覧を、IP アドレスや仮想サーバの品目などとあわせて表示します。

    ~~~~ {.shell}
    $ vagrant gc-list
    gpXXXXXXXX	gcYYYYYYYY	V240	CentOS6_64_U	L	XXX.XXX.XX.XX	XX.XXX.XX.XX	label
    ~~~~


## Box Format

全ての Vagrant provider は、それ用にカスタムの box を導入する必要があります。
box の例は example_box/ ディレクトリにあります。

## Configuration

IIJ GIP provider 固有の設定は以下の通りとなります:

-   必須パラメータ
    -   `access_key` - IIJ API にアクセスするためのアクセスキー
    -   `secret_key` - IIJ API にアクセスするためのシークレット
    -   `gp_service_code` - 仮想サーバを実行する gp サービスコード
    -   `ssh_public_key` - 仮想サーバにアクセスするための SSH 公開鍵の内容。
        この設定は、仮想サーバを最初に起動する際のみ利用されます。
        もし、SSH キーの設定を変更したい場合、仮想サーバの初期化をするか、
        手動で ImportRootSshPublicKey API を実行する必要があります。
-   任意
    -   `label` - 仮想サーバのラベル。もし設定が無い場合には vagrant の vm name が利用されます
    -   `virtual_machine_type` - 仮想サーバの品目。この設定は新規に仮想サーバを契約する場合のみ必要です
    -   `os` - OS の種類。Chef provisioner を利用する場合、CentOS6 のイメージを指定する必要があります

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
