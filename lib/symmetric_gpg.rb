# A gpg command line wrapper for symmetric encryption
module SymmetricGPG
  VERSION = '1.0.0'

  CRYPTOR = 'gpg -q --batch --passphrase-fd 0'
  ENCRYPTING = '--force-mdc --symmetric'
  DECRYPTING = '--decrypt'

  class Data
    attr_accessor :passphrase, :plain, :encrypted, :force
    attr_accessor :cryptor, :encrypting, :decrypting

    def initialize(passphrase,plain=nil,encrypted=nil,force=true)
      @passphrase, @plain, @encrypted, @force = passphrase, plain, encrypted, force
      @cryptor, @encrypting, @decrypting = CRYPTOR, ENCRYPTING, DECRYPTING
    end
  end

  autoload :Files,	'symmetric_gpg/files'
  autoload :IOs,	'symmetric_gpg/ios'
  autoload :Strings,	'symmetric_gpg/strings'
end
